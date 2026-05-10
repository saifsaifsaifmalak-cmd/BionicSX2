#import "AppDelegate.h"
#import "GameLibraryViewController.h"
#import "MetalViewController.h"

@interface BionicSX2AppDelegate () <GameLibraryDelegate>
@property (nonatomic, strong) MetalViewController* emulatorVC;
@end

@implementation BionicSX2AppDelegate

- (BOOL)application:(UIApplication*)app
    didFinishLaunchingWithOptions:(NSDictionary*)opts {

    self.window = [[UIWindow alloc]
        initWithFrame:UIScreen.mainScreen.bounds];

    GameLibraryViewController* lib = [[GameLibraryViewController alloc] init];
    lib.delegate = self;

    UINavigationController* nav = [[UINavigationController alloc]
        initWithRootViewController:lib];
    nav.navigationBar.barTintColor = UIColor.blackColor;
    nav.navigationBar.titleTextAttributes =
        @{NSForegroundColorAttributeName: UIColor.whiteColor};

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)gameLibraryDidSelectISO:(NSString*)isoPath {
    self.emulatorVC = [[MetalViewController alloc] init];
    self.emulatorVC.isoPath = isoPath;
    self.emulatorVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.window.rootViewController
        presentViewController:self.emulatorVC
                     animated:YES completion:nil];
}

- (void)gameLibraryDidSelectBIOS:(NSString*)biosPath {
    UIAlertController* a = [UIAlertController
        alertControllerWithTitle:@"BIOS Imported ✓"
                         message:biosPath.lastPathComponent
                  preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction
        actionWithTitle:@"OK"
                  style:UIAlertActionStyleDefault
                handler:nil]];
    [self.window.rootViewController
        presentViewController:a animated:YES completion:nil];
}

@end
