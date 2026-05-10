// EmulatorBridge.mm — Phase 6: VMManager enabled
#import <Foundation/Foundation.h>

#include "EmulatorBridge.h"
#include "VMManager.h"
#include "Config.h"
#include "common/Error.h"

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

bool EmulatorBridge_BootBIOS(const char* biosPath) {
    NSLog(@"[BionicSX2] BootBIOS: %s", biosPath ? biosPath : "(null)");

    VMBootParameters params;
    params.filename = "";
    params.fast_boot = false;

    Error error;
    VMBootResult result = VMManager::Initialize(params, &error);

    if (result != VMBootResult::StartupSuccess) {
        NSLog(@"[BionicSX2] Initialize failed: %s", error.GetDescription().c_str());
        return false;
    }

    VMManager::SetState(VMState::Running);
    NSLog(@"[BionicSX2] VMManager::Initialize SUCCESS");
    return true;
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