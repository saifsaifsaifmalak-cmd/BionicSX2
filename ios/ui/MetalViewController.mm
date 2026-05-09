#import "MetalViewController.h"
#import <AVFoundation/AVFoundation.h>

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
    if (!EmulatorBridge_Init()) {
        NSLog(@"[BionicSX2] ERROR: EmulatorBridge_Init failed");
        return;
    }

    NSString* docsPath = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString* biosDir = [docsPath stringByAppendingPathComponent:@"bios"];

    NSFileManager* fm = [NSFileManager defaultManager];
    NSArray* files = [fm contentsOfDirectoryAtPath:biosDir error:nil];
    NSString* biosFile = nil;

    for (NSString* f in files) {
        if ([f.pathExtension.lowercaseString isEqualToString:@"bin"]) {
            biosFile = [biosDir stringByAppendingPathComponent:f];
            break;
        }
    }

    if (!biosFile) {
        NSLog(@"[BionicSX2] No BIOS found in %@ — check Documents/bios/ folder",
              biosDir);
        return;
    }

    NSLog(@"[BionicSX2] Found BIOS: %@", biosFile);

    if (EmulatorBridge_BootBIOS(biosFile.UTF8String)) {
        NSLog(@"[BionicSX2] BIOS boot started");
        self.emulatorInitialized = YES;
    } else {
        NSLog(@"[BionicSX2] BIOS boot failed");
    }
}

- (void)startEmulatorLoop {
    NSLog(@"[BionicSX2] Emulator loop started");
}

- (void)stopEmulatorLoop {
    if (self.emulatorInitialized) {
        EmulatorBridge_Shutdown();
    }
    NSLog(@"[BionicSX2] Emulator loop stopped");
}

- (void)drawInMTKView:(MTKView*)view {
    if (self.emulatorInitialized) {
        EmulatorBridge_RunFrame();
    }

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

- (void)dealloc {
    if (self.emulatorInitialized) {
        EmulatorBridge_Shutdown();
    }
}

@end