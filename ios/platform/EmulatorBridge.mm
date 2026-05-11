// EmulatorBridge.mm — Phase 6: VMManager enabled
#import <Foundation/Foundation.h>

#include "EmulatorBridge.h"
#include "VMManager.h"
#include "Config.h"
#include "common/Error.h"
#include "CDVD/CDVDcommon.h"

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

bool EmulatorBridge_BootGame(const char* biosPath, const char* isoPath) {
    NSLog(@"[BionicSX2] EmulatorBridge_BootGame called");
    NSLog(@"[BionicSX2]   bios: %s", biosPath ? biosPath : "(null)");
    NSLog(@"[BionicSX2]   iso:  %s", isoPath ? isoPath : "(null)");

#if 1
    VMBootParameters params;

    if (isoPath && strlen(isoPath) > 0) {
        params.filename = isoPath;
        params.source_type = CDVD_SourceType::Iso;
    } else {
        params.filename = "";
        params.source_type = CDVD_SourceType::NoDisc;
    }

    params.fast_boot = false;
    params.fullscreen = false;

    Error error;
    VMBootResult result = VMManager::Initialize(params, &error);

    if (result != VMBootResult::StartupSuccess) {
        NSLog(@"[BionicSX2] Boot failed: %s", error.GetDescription().c_str());
        return false;
    }

    NSLog(@"[BionicSX2] PS2 running");
#else
    NSLog(@"[BionicSX2] VMManager stub — boot deferred to Phase 8");
#endif
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