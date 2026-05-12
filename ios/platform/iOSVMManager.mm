// iOSVMManager.mm — PS2 VM initialization for iOS
// Phase 7: Manual init with correct PCSX2 boot sequence

#import <Foundation/Foundation.h>

#include "VMManager.h"
#include "CDVD/CDVD.h"
#include "CDVD/CDVDcommon.h"
#include "Config.h"
#include "Memory.h"
#include "R5900.h"
#include "GS/GS.h"
#include "SPU2/spu2.h"
#include "DEV9/DEV9.h"
#include "USB/USB.h"
#include "ps2/BiosTools.h"
#include "common/Console.h"
#include "common/Error.h"
#include "common/FileSystem.h"
#include "BionicLogger.hpp"

#include <thread>
#include <signal.h>

extern "C" {

static bool s_iOSVM_initialized = false;
static std::thread s_ee_thread;
static bool s_ee_thread_running = false;

static void ShutdownSignalHandler(int) {
    if (s_ee_thread_running) {
        s_ee_thread_running = false;
        if (Cpu)
            Cpu->ExitExecution();
    }
}

bool iOSVM_Initialize(const char* isoPath) {
    if (s_iOSVM_initialized) return true;

    Console.WriteLn("[BionicSX2] iOSVM_Initialize start");
    BionicLogger::instance().flush();

    signal(SIGUSR1, ShutdownSignalHandler);

    if (!SysMemory::Allocate()) {
        Console.WriteLn("[BionicSX2] SysMemory::Allocate failed");
        BionicLogger::instance().flush();
        return false;
    }

    if (!cdvdLock(nullptr)) {
        Console.WriteLn("[BionicSX2] cdvdLock failed");
        SysMemory::Release();
        return false;
    }

    if (isoPath && strlen(isoPath) > 0) {
        CDVDsys_SetFile(CDVD_SourceType::Iso, isoPath);
        CDVDsys_ChangeSource(CDVD_SourceType::Iso);
    } else {
        CDVDsys_ChangeSource(CDVD_SourceType::NoDisc);
    }

    if (!LoadBIOS()) {
        Console.WriteLn("[BionicSX2] LoadBIOS failed — no BIOS found in %s", EmuFolders::Bios.c_str());
        BionicLogger::instance().flush();
        FileSystem::FindResultsArray results;
        FileSystem::FindFiles(EmuFolders::Bios.c_str(), "*", FILESYSTEM_FIND_FILES, &results);
        for (const auto& fd : results)
            Console.WriteLn("  Found: %s (%lld bytes)", fd.FileName.c_str(), fd.Size);
        BionicLogger::instance().flush();
        cdvdUnlock();
        SysMemory::Release();
        return false;
    }
    cdvdLoadNVRAM();

    if (CDVDsys_GetSourceType() != CDVD_SourceType::NoDisc) {
        Error cdvd_error;
        if (!DoCDVDopen(&cdvd_error)) {
            Console.WriteLn("[BionicSX2] DoCDVDopen failed: %s", cdvd_error.GetDescription().c_str());
            BionicLogger::instance().flush();
        }
    }

    Console.WriteLn("[BionicSX2] Resetting CPU...");
    BionicLogger::instance().flush();
    cpuReset();

    USBinit();
    DEV9init();
    SPU2::Open();
    EmuConfig.GS.Renderer = GSRendererType::Null;
    GSopen(EmuConfig.GS, EmuConfig.GS.Renderer, SysMemory::GetEEMem(), GSVSyncMode::Disabled, true);
    Console.WriteLn("[BionicSX2] Subsystems initialized");
    BionicLogger::instance().flush();

    VMManager::SetState(VMState::Paused);
    Host::OnVMStarted();
    VMManager::SetPaused(false);

    s_ee_thread_running = true;
    s_ee_thread = std::thread([]() {
        VMManager::Execute();
        s_ee_thread_running = false;
    });

    s_iOSVM_initialized = true;
    Console.WriteLn("[BionicSX2] iOSVM_Initialize complete");
    BionicLogger::instance().flush();
    return true;
}

void iOSVM_RunFrame(void) {
    if (!s_iOSVM_initialized) return;
    VMManager::IdlePollUpdate();
}

void iOSVM_Shutdown(void) {
    if (!s_iOSVM_initialized) return;

    Console.WriteLn("[BionicSX2] iOSVM_Shutdown");
    BionicLogger::instance().flush();

    if (s_ee_thread_running && s_ee_thread.joinable()) {
        pthread_kill(s_ee_thread.native_handle(), SIGUSR1);
        s_ee_thread.join();
    }

    VMManager::Shutdown(false);
    s_iOSVM_initialized = false;
}

} // extern "C"
