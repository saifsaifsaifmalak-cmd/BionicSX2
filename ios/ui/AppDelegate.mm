#import "AppDelegate.h"
#import "MetalViewController.h"

@implementation BionicSX2AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {

    self.window = [[UIWindow alloc]
        initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.blackColor;

    MetalViewController* vc = [[MetalViewController alloc] init];
    self.window.rootViewController = vc;

    [self.window makeKeyAndVisible];

    NSLog(@"[BionicSX2] App launched — Phase 3 foundation");
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication*)application {
    NSLog(@"[BionicSX2] Entering background");
}

- (void)applicationWillEnterForeground:(UIApplication*)application {
    NSLog(@"[BionicSX2] Entering foreground");
}

@end
