// EmulatorBridge.mm — Phase 6: VMManager enabled
#import <Foundation/Foundation.h>

#include "EmulatorBridge.h"
#include "VMManager.h"
#include "Config.h"
#include "common/Error.h"
#include "iOSVMManager.h"
#include "Watchdog.hpp"
#include "BionicLogger.hpp"

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
    Watchdog_Stop();
}

bool EmulatorBridge_BootGame(const char* isoPath) {
    NSLog(@"[BionicSX2] EmulatorBridge_BootGame: %s", isoPath ? isoPath : "(null)");

    BionicLogger::instance().log("INFO ", "CORE ", "EmulatorBridge_BootGame: starting VMManager");
    Watchdog_Start();
    bool result = iOSVM_Initialize(isoPath);

    if (result) {
        NSLog(@"[BionicSX2] iOSVM initialized — PS2 running");
    } else {
        NSLog(@"[BionicSX2] iOSVM_Initialize failed");
        Watchdog_Stop();
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