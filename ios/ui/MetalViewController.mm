#import "MetalViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#include "platform/EmulatorBridge.h"

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
        NSLog(@"[BionicSX2] AudioEngine running (silent)");
    }
}

- (void)initializeEmulator {
    if (!EmulatorBridge_Init()) {
        NSLog(@"[BionicSX2] EmulatorBridge_Init failed");
        return;
    }
    NSLog(@"[BionicSX2] Emulator initialized (stub mode)");
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
    // Stub - no rendering yet
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
    NSLog(@"[BionicSX2] Touch %@ at %@", pressed ? @"down" : @"up", NSStringFromCGPoint(pt));
}

@end