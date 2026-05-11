// EmulatorBridge.mm — Phase 6: VMManager enabled
#import <Foundation/Foundation.h>

#include "EmulatorBridge.h"
#include "VMManager.h"
#include "Config.h"
#include "common/Error.h"
#include "iOSVMManager.h"

extern "C" {

bool EmulatorBridge_Init(void) {
    NSLog(@"[BionicSX2] EmulatorBridge_Init");
    return true;
}

void EmulatorBridge_Shutdown(void) {
    NSLog(@"[BionicSX2] EmulatorBridge_Shutdown");
    if (VMManager::GetState() != VMState::Shutdown) {
        VMManager::Shutdown(false);
    }
}

bool EmulatorBridge_BootGame(const char* isoPath) {
    NSLog(@"[BionicSX2] EmulatorBridge_BootGame: %s", isoPath ? isoPath : "(null)");

    bool result = iOSVM_Initialize(isoPath);

    if (result) {
        NSLog(@"[BionicSX2] iOSVM initialized — PS2 running");
    } else {
        NSLog(@"[BionicSX2] iOSVM_Initialize failed");
    }

    return result;
}

void EmulatorBridge_RunFrame(void) {
    if (VMManager::GetState() == VMState::Running) {
        VMManager::Execute();
    }
}

bool EmulatorBridge_IsRunning(void) {
    return VMManager::GetState() == VMState::Running;
}

} // extern "C"