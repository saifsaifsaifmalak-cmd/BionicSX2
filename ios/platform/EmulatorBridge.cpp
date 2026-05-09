// EmulatorBridge.cpp — C++ bridge implementation
// Provides extern "C" interface to PCSX2 VMManager for Objective-C callers
// Phase 4: BIOS boot via interpreter

#include "EmulatorBridge.h"
#include "VMManager.h"
#include "Host.h"
#include "Config.h"
#include "common/Console.h"
#include "common/FileSystem.h"
#include "common/Error.h"
#include "common/SettingsInterface.h"
#include "common/MemorySettingsInterface.h"

static MemorySettingsInterface s_settings_interface;

extern "C" {

bool EmulatorBridge_Init(void) {
    Console.WriteLn("[BionicSX2] EmulatorBridge_Init");

    VMManager::Internal::LoadStartupSettings();

    s_settings_interface.SetStringValue("BIOS", "BB_BIOS", "SCPH-10000.BIN");

    Host::Internal::SetBaseSettingsLayer(&s_settings_interface);
    Host::Internal::SetSecretsSettingsLayer(&s_settings_interface);

    VMManager::Internal::UpdateEmuFolders();

    const char* error = nullptr;
    if (!VMManager::PerformEarlyHardwareChecks(&error)) {
        Console.WriteLn("[BionicSX2] Hardware check failed: %s", error ? error : "unknown");
        return false;
    }

    return true;
}

void EmulatorBridge_Shutdown(void) {
    Console.WriteLn("[BionicSX2] EmulatorBridge_Shutdown");
    if (VMManager::GetState() != VMState::Shutdown) {
        VMManager::Shutdown(false);
    }
}

bool EmulatorBridge_BootBIOS(const char* biosPath) {
    Console.WriteLn("[BionicSX2] EmulatorBridge_BootBIOS: %s", biosPath ? biosPath : "(null)");

    VMBootParameters params;
    if (biosPath && biosPath[0]) {
        params.elf_override = biosPath;
    }

    Error error;
    VMBootResult result = VMManager::Initialize(params, &error);
    if (result == VMBootResult::StartupSuccess) {
        Console.WriteLn("[BionicSX2] VM started successfully");
        return true;
    } else {
        Console.WriteLn("[BionicSX2] VM boot failed: %s",
            error.IsValid() ? error.GetDescription().c_str() : "unknown error");
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