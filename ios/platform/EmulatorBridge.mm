// EmulatorBridge.mm — Phase 5 real implementation
// Provides extern "C" interface to PCSX2 VMManager for Objective-C callers
// Phase 5: Links pcsx2_core, calls VMManager for real BIOS boot

#import <Foundation/Foundation.h>

#include "EmulatorBridge.h"
#include "VMManager.h"
#include "Host.h"
#include "common/Console.h"
#include "SettingsInterface.h"

static MemorySettingsInterface s_settings_interface;

extern "C" {

bool EmulatorBridge_Init(void) {
    NSLog(@"[BionicSX2] EmulatorBridge_Init");
    
    // Load startup settings
    VMManager::Internal::LoadStartupSettings();
    
    // Configure BIOS settings
    s_settings_interface.SetStringValue("BIOS", "BB_BIOS", "SCPH-10000.BIN");
    
    // Set settings layers
    Host::Internal::SetBaseSettingsLayer(&s_settings_interface);
    Host::Internal::SetSecretsSettingsLayer(&s_settings_interface);
    
    VMManager::Internal::UpdateEmuFolders();
    
    // Perform hardware checks
    const char* error = nullptr;
    if (!VMManager::PerformEarlyHardwareChecks(&error)) {
        NSLog(@"[BionicSX2] Hardware check failed: %s", error ? error : "unknown");
        return false;
    }
    
    NSLog(@"[BionicSX2] EmulatorBridge_Init complete");
    return true;
}

void EmulatorBridge_Shutdown(void) {
    NSLog(@"[BionicSX2] EmulatorBridge_Shutdown");
    if (VMManager::GetState() != VMState::Shutdown) {
        VMManager::Shutdown(false);
    }
}

bool EmulatorBridge_BootBIOS(const char* biosPath) {
    NSLog(@"[BionicSX2] EmulatorBridge_BootBIOS: %s", biosPath ? biosPath : "(null)");
    
    VMBootParameters params;
    if (biosPath && biosPath[0]) {
        params.elf_override = biosPath;
    }
    
    VMBootResult result = VMManager::Initialize(params);
    
    if (result == VMBootResult::StartupSuccess) {
        NSLog(@"[BionicSX2] VM started successfully");
        return true;
    } else {
        NSLog(@"[BionicSX2] VM boot failed with result: %d", (int)result);
        return false;
    }
}

void EmulatorBridge_RunFrame(void) {
    VMState state = VMManager::GetState();
    if (state == VMState::Running) {
        VMManager::Execute();
    } else if (state == VMState::Paused) {
        VMManager::IdlePollUpdate();
    }
}

bool EmulatorBridge_IsRunning(void) {
    return VMManager::GetState() == VMState::Running;
}

} // extern "C"