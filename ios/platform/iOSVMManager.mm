// iOSVMManager.mm — Minimal PS2 boot for iOS
// Bypasses VMManager::Initialize (454 undefined symbols)
// Boots: Memory → CPU → GS(Metal) → SPU2 → CDVD

#import <Foundation/Foundation.h>
#include "common/Console.h"
#include "common/Error.h"
#include "Memory.h"
#include "R5900.h"
#include "GS/GS.h"
#include "SPU2/spu2.h"
#include "CDVD/CDVD.h"
#include "Config.h"
#include "Host.h"

static bool s_iOSVM_initialized = false;

bool iOSVM_Initialize(const char* isoPath) {
    if (s_iOSVM_initialized) {
        Console.WriteLn("[BionicSX2] iOSVM already initialized");
        return true;
    }

    Console.WriteLn("[BionicSX2] iOSVM_Initialize start");

    // Step 1: Memory subsystem
    Console.WriteLn("[BionicSX2] Allocating memory...");
    if (!SysMemory::Allocate()) {
        Console.WriteLn("[BionicSX2] SysMemory::Allocate failed");
        return false;
    }
    Console.WriteLn("[BionicSX2] Memory allocated OK");

    // Step 2: CPU reset
    Console.WriteLn("[BionicSX2] Resetting CPU...");
    cpuReset();
    Console.WriteLn("[BionicSX2] CPU reset OK");

    // Step 3: GS - Metal renderer (via MTGS wrapper)
    Console.WriteLn("[BionicSX2] Opening GS (Metal)...");
    if (!MTGS::WaitForOpen()) {
        Console.WriteLn("[BionicSX2] MTGS::WaitForOpen failed");
        return false;
    }
    Console.WriteLn("[BionicSX2] GS opened OK");

    // Step 4: SPU2 audio
    Console.WriteLn("[BionicSX2] Opening SPU2...");
    if (!SPU2::Open()) {
        Console.WriteLn("[BionicSX2] SPU2::Open failed");
        return false;
    }
    Console.WriteLn("[BionicSX2] SPU2 opened OK");

    // Step 5: CDVD - ISO or disc
    Console.WriteLn("[BionicSX2] Opening CDVD...");
    if (isoPath && strlen(isoPath) > 0) {
        CDVDsys_SetFile(CDVD_SourceType::Iso, std::string(isoPath));
        CDVDsys_ChangeSource(CDVD_SourceType::Iso);
    } else {
        CDVDsys_ChangeSource(CDVD_SourceType::NoDisc);
    }

    if (!CDVDapi_IsoOpen()) {
        Console.WriteLn("[BionicSX2] CDVDapi_IsoOpen failed");
        return false;
    }
    Console.WriteLn("[BionicSX2] CDVD opened OK");

    // Step 6: Pad (input)
    Console.WriteLn("[BionicSX2] Opening PAD...");
    // Pad::Initialize - skip for Phase 8, input handled separately

    s_iOSVM_initialized = true;
    Console.WriteLn("[BionicSX2] iOSVM_Initialize complete");
    return true;
}

void iOSVM_RunFrame(void) {
    if (!s_iOSVM_initialized) return;

    // Execute interpreter for one frame
    cpuExecute();
}

void iOSVM_Shutdown(void) {
    if (!s_iOSVM_initialized) return;

    Console.WriteLn("[BionicSX2] iOSVM_Shutdown");

    SPU2::Close();

    if (MTGS::IsOpen()) {
        MTGS::WaitForClose();
    }

    SysMemory::Release();

    s_iOSVM_initialized = false;
    Console.WriteLn("[BionicSX2] iOSVM shutdown complete");
}