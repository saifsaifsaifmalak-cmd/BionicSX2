// BionicSX2 — iOS Entry Point
#import <UIKit/UIKit.h>
#import "ui/AppDelegate.h"
#include "BionicLogger.hpp"

int main(int argc, char* argv[]) {
    @autoreleasepool {
        // Capture Objective-C exception reason before abort
        NSSetUncaughtExceptionHandler(^(NSException* exc) {
            BionicLogger::instance().log("FATAL", "UI   ",
                [[NSString stringWithFormat:@"ObjC exception: %@\n  Reason: %@\n  Stack: %@",
                    exc.name, exc.reason, exc.callStackSymbols] UTF8String]);
            BionicLogger::instance().flush();
        });

        return UIApplicationMain(
            argc, argv,
            nil,
            NSStringFromClass([BionicSX2AppDelegate class])
        );
    }
}
