#import "MetalViewController.h"
#import <AVFoundation/AVFoundation.h>

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
    [self startEmulatorLoop];
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

- (void)startEmulatorLoop {
    self.emulatorRunning = YES;
    NSLog(@"[BionicSX2] Emulator loop started (Phase 3 — no game loaded)");
}

- (void)stopEmulatorLoop {
    self.emulatorRunning = NO;
    NSLog(@"[BionicSX2] Emulator loop stopped");
}

- (void)drawInMTKView:(MTKView*)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor* rpd = view.currentRenderPassDescriptor;

    if (rpd) {
        id<MTLRenderCommandEncoder> encoder =
            [commandBuffer renderCommandEncoderWithDescriptor:rpd];
        [encoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"[BionicSX2] Metal view size: %.0fx%.0f",
          size.width, size.height);
}

@end
