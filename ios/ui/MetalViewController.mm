#import "MetalViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#include "platform/EmulatorBridge.h"
#include "Input/InputManager.h"
#include "Config.h"

@interface MetalViewController ()
@property (nonatomic, strong) AVAudioEngine*     audioEngine;
@property (nonatomic, assign) BOOL               emulatorRunning;
@end

@implementation MetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.device = MTLCreateSystemDefaultDevice();
    NSAssert(self.device, @"Metal not available on this device");

    self.commandQueue = [self.device newCommandQueue];

    self.metalView = [[MTKView alloc] initWithFrame:self.view.bounds
                                             device:self.device];
    self.metalView.delegate             = self;
    self.metalView.preferredFramesPerSecond = 60;
    self.metalView.clearColor           = MTLClearColorMake(0, 0, 0, 1);
    self.metalView.colorPixelFormat     = MTLPixelFormatBGRA8Unorm;
    self.metalView.autoresizingMask     =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;

    [self.view insertSubview:self.metalView atIndex:0];

    [self setupAudioEngine];
    [self initializeEmulator];
}

- (void)setupAudioEngine {
    NSError* error = nil;

    [[AVAudioSession sharedInstance]
        setCategory:AVAudioSessionCategoryPlayback
              error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];

    self.audioEngine = [[AVAudioEngine alloc] init];

    [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"[BionicSX2] AudioEngine start error: %@", error);
    } else {
        NSLog(@"[BionicSX2] AudioEngine running (silent — Phase 3)");
    }
}

- (void)initializeEmulator {
    if (!EmulatorBridge_Init()) {
        NSLog(@"[BionicSX2] EmulatorBridge_Init failed");
        return;
    }

    NSString* docs = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString* biosDir = [docs stringByAppendingPathComponent:@"bios"];
    NSArray* files = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtPath:biosDir error:nil];

    NSString* biosFile = nil;
    for (NSString* f in files) {
        if ([f.pathExtension.lowercaseString isEqualToString:@"bin"]) {
            biosFile = [biosDir stringByAppendingPathComponent:f];
            break;
        }
    }

    if (!biosFile) {
        NSLog(@"[BionicSX2] No BIOS in %@ — boot skipped", biosDir);
        NSLog(@"[BionicSX2] Place SCPH-XXXXX.bin in Documents/bios/");
        return;
    }

    NSLog(@"[BionicSX2] BIOS found: %@", biosFile);
    if (EmulatorBridge_BootBIOS(biosFile.UTF8String)) {
        self.emulatorRunning = YES;
        NSLog(@"[BionicSX2] PS2 interpreter running");
    }
}

- (void)startEmulatorLoop {
    NSLog(@"[BionicSX2] Emulator loop started");
}

- (void)stopEmulatorLoop {
    NSLog(@"[BionicSX2] Stopping emulator");
    self.emulatorRunning = NO;
    EmulatorBridge_Shutdown();
}

- (void)drawMTKView:(MTKView*)view {
    if (self.emulatorRunning && EmulatorBridge_IsRunning()) {
        EmulatorBridge_RunFrame();
    }
}

- (void)mtkView:(MTKView*)view drawableSizeDidChange:(CGSize)size {
    NSLog(@"[BionicSX2] drawableSizeDidChange: %@", NSStringFromCGSize(size));
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
    for (UITouch* t in touches) {
        CGPoint pt = [t locationInView:self.view];
        [self handleTouch:pt pressed:YES];
    }
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
    for (UITouch* t in touches) {
        CGPoint pt = [t locationInView:self.view];
        [self handleTouch:pt pressed:NO];
    }
}

- (void)touchesCancelled:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)handleTouch:(CGPoint)pt pressed:(BOOL)pressed {
    CGSize sz = self.view.bounds.size;
    float value = pressed ? 1.0f : 0.0f;

    if (pt.x < sz.width * 0.5f) {
        CGPoint c = CGPointMake(sz.width * 0.25f, sz.height * 0.75f);
        float dx = pt.x - c.x;
        float dy = pt.y - c.y;
        if (fabsf(dx) > fabsf(dy)) {
            [self sendInput:(dx > 0) ? GenericInputBinding::DPadRight : GenericInputBinding::DPadLeft value:value];
        } else {
            [self sendInput:(dy > 0) ? GenericInputBinding::DPadDown : GenericInputBinding::DPadUp value:value];
        }
    } else {
        if (pt.y > sz.height * 0.6f) {
            [self sendInput:(pt.x > sz.width * 0.75f) ? GenericInputBinding::Circle : GenericInputBinding::Cross value:value];
        }
    }
}

- (void)sendInput:(GenericInputBinding)btn value:(float)val {
    InputManager::InvokeEvents(InputBindingKey{}, val, btn);
}

@end