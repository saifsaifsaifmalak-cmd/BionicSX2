#import "MetalViewController.h"
#import <AVFoundation/AVFoundation.h>
#include "platform/EmulatorBridge.h"

@interface MetalViewController ()
@property (nonatomic, strong) AVAudioEngine*     audioEngine;
@property (nonatomic, assign) BOOL               emulatorInitialized;
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
    NSLog(@"[BionicSX2] initializeEmulator — Phase 4 stub (no core linked)");

    // Don't call any PCSX2 functions - bios check will be Phase 6
    self.emulatorInitialized = YES;
}

- (void)startEmulatorLoop {
    NSLog(@"[BionicSX2] Emulator loop started");
}

- (void)stopEmulatorLoop {
    NSLog(@"[BionicSX2] Stopping emulator");
    self.emulatorInitialized = NO;
}

- (void)drawMTKView:(MTKView*)view {
    // Simple clear - wait for Phase 6 GSDeviceMTL
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    MTLRenderPassDescriptor* passDesc = self.metalView.currentRenderPassDescriptor;
    if (passDesc) {
        passDesc.clearColor = MTLClearColorMake(0, 0, 0, 1);
        id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor:passDesc];
        [encoder endEncoding];
        [commandBuffer presentDrawable:self.metalView.currentDrawable];
    }
    
    [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeDidChange:(CGSize)size {
    NSLog(@"[BionicSX2] drawableSizeDidChange: %@", NSStringFromCGSize(size));
}

@end