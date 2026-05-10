// EmulatorBridge.cpp — Phase 4 stub implementation
// Provides extern "C" interface to PCSX2 VMManager for Objective-C callers
//
// Phase 4: Stub only — pcsx2_core not yet linked
// TODO Phase 5: uncomment real implementations when Metal + Host ready

#include "EmulatorBridge.h"
#include <Foundation/Foundation.h>

extern "C" {

bool EmulatorBridge_Init(void) {
    NSLog(@"[BionicSX2] EmulatorBridge_Init — Phase 4 stub");
    // TODO Phase 5: call VMManager::Initialize() via Host:: callbacks
    return true;
}

void EmulatorBridge_Shutdown(void) {
    NSLog(@"[BionicSX2] EmulatorBridge_Shutdown — Phase 4 stub");
    // TODO Phase 5: call VMManager::Shutdown()
}

bool EmulatorBridge_BootBIOS(const char* biosPath) {
    NSLog(@"[BionicSX2] EmulatorBridge_BootBIOS stub: %s", biosPath ? biosPath : "(null)");
    // TODO Phase 5: call VMManager::Initialize()
    return false;
}

void EmulatorBridge_RunFrame(void) {
    // TODO Phase 5: call VMManager::Execute()
}

bool EmulatorBridge_IsRunning(void) {
    return false; // TODO Phase 5
}

} // extern "C"