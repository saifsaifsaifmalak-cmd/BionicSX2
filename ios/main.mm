// BionicSX2 — iOS Entry Point
#import <UIKit/UIKit.h>
#import "ui/AppDelegate.h"

int main(int argc, char* argv[]) {
    @autoreleasepool {
        return UIApplicationMain(
            argc, argv,
            nil,
            NSStringFromClass([BionicSX2AppDelegate class])
        );
    }
}
