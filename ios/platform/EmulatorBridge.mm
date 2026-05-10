// EmulatorBridge.mm — Phase 4 stub implementation (core not linked)
#import <Foundation/Foundation.h>

#include "EmulatorBridge.h"

extern "C" {

bool EmulatorBridge_Init(void) {
    NSLog(@"[BionicSX2] EmulatorBridge_Init — Phase 4 stub");
    return true;
}

void EmulatorBridge_Shutdown(void) {
    NSLog(@"[BionicSX2] EmulatorBridge_Shutdown — Phase 4 stub");
}

bool EmulatorBridge_BootBIOS(const char* biosPath) {
    NSLog(@"[BionicSX2] EmulatorBridge_BootBIOS stub: %s", biosPath ? biosPath : "(null)");
    return false;
}

void EmulatorBridge_RunFrame(void) {
    // Stub - no execution
}

bool EmulatorBridge_IsRunning(void) {
    return false;
}

} // extern "C"