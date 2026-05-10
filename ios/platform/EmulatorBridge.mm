// EmulatorBridge.mm — Phase 6: Real VMManager boot
#import <Foundation/Foundation.h>

#include "EmulatorBridge.h"
#include "VMManager.h"
#include "Config.h"
#include "common/Console.h"
#include "common/Error.h"

extern "C" {

bool EmulatorBridge_Init(void) {
    Console.WriteLn("[BionicSX2] EmulatorBridge_Init");

    // Force interpreter mode — no JIT on iOS Phase 6
    EmuConfig.Cpu.Recompiler.EnableEE  = false;
    EmuConfig.Cpu.Recompiler.EnableIOP = false;
    EmuConfig.Cpu.Recompiler.EnableVU0 = false;
    EmuConfig.Cpu.Recompiler.EnableVU1 = false;

    // Set BIOS directory to iOS Documents/bios/
    NSString* docs = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString* biosDir = [docs stringByAppendingPathComponent:@"bios"];
    EmuConfig.BiosFilename = biosDir.UTF8String;

    Console.WriteLn("[BionicSX2] BIOS dir: %s", EmuConfig.BiosFilename.c_str());
    return true;
}

void EmulatorBridge_Shutdown(void) {
    Console.WriteLn("[BionicSX2] EmulatorBridge_Shutdown");
    if (VMManager::GetState() != VMState::Shutdown) {
        VMManager::Shutdown(false);
    }
}

bool EmulatorBridge_BootBIOS(const char* biosPath) {
    Console.WriteLn("[BionicSX2] Booting BIOS: %s", biosPath);

    VMBootParameters params;
    params.filename   = "";
    params.fast_boot  = false;

    Error error;
    VMBootResult result = VMManager::Initialize(params, &error);

    if (result != VMBootResult::StartupSuccess) {
        Console.WriteLn("[BionicSX2] Initialize failed: %s",
                        error.GetDescription().c_str());
        return false;
    }

    VMManager::SetState(VMState::Running);
    Console.WriteLn("[BionicSX2] BIOS boot started");
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