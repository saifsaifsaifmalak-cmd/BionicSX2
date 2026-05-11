// EmulatorBridge.mm — Phase 6: VMManager enabled
#import <Foundation/Foundation.h>

#include "EmulatorBridge.h"
#include "VMManager.h"
#include "Config.h"
#include "common/Error.h"
#include "iOSVMManager.h"
#include "Watchdog.hpp"
#include "BionicLogger.hpp"
#include "PCSX2LogRedirect.h"

extern "C" {

bool EmulatorBridge_Init(void) {
    NSLog(@"[BionicSX2] EmulatorBridge_Init");
    PCSX2Log_Init();
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
    BionicLogger::instance().flush();

    try {
        Watchdog_Start();
        bool result = iOSVM_Initialize(isoPath);

        BionicLogger::instance().log("INFO ", "CORE ", "iOSVM_Initialize returned.");
        BionicLogger::instance().flush();

        if (result) {
            NSLog(@"[BionicSX2] iOSVM initialized — PS2 running");
        } else {
            NSLog(@"[BionicSX2] iOSVM_Initialize failed");
            Watchdog_Stop();
        }

        return result;
    } catch (const std::exception& e) {
        BionicLogger::instance().log("ERROR", "CORE ", "Boot exception: %s", e.what());
        BionicLogger::instance().flush();
        Watchdog_Stop();
        return false;
    } catch (...) {
        BionicLogger::instance().log("FATAL", "CORE ", "Boot exception: unknown");
        BionicLogger::instance().flush();
        Watchdog_Stop();
        return false;
    }
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