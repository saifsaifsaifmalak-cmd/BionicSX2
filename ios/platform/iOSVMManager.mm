// iOSVMManager.mm — Minimal PS2 boot for iOS
// Phase 8: Stub mode — builds, real init deferred

#import <Foundation/Foundation.h>
#include "common/Console.h"
#include "common/Error.h"
#include "Memory.h"
#include "R5900.h"
#include "Config.h"
#include "BionicLogger.hpp"

extern "C" {

static bool s_iOSVM_initialized = false;

bool iOSVM_Initialize(const char* isoPath) {
    if (s_iOSVM_initialized) return true;

    Console.WriteLn("[BionicSX2] iOSVM_Initialize start");
    BionicLogger::instance().flush();

    // Phase 8: Stub - just allocate memory
    Console.WriteLn("[BionicSX2] Allocating memory...");
    BionicLogger::instance().flush();
    if (!SysMemory::Allocate()) {
        Console.WriteLn("[BionicSX2] SysMemory::Allocate failed");
        BionicLogger::instance().flush();
        return false;
    }
    BionicLogger::instance().flush();

    // CPU reset (minimal interpreter-only)
    Console.WriteLn("[BionicSX2] Resetting CPU...");
    BionicLogger::instance().flush();
    cpuReset();

    // TODO Phase 9: GS Metal, SPU2, CDVD real init
    Console.WriteLn("[BionicSX2] GS/SPU2/CDVD init deferred to Phase 9");
    BionicLogger::instance().flush();

    s_iOSVM_initialized = true;
    Console.WriteLn("[BionicSX2] iOSVM_Initialize complete (STUB)");
    BionicLogger::instance().flush();
    return true;
}

void iOSVM_RunFrame(void) {
    // TODO Phase 9: cpuExecute() in interpreter
}

void iOSVM_Shutdown(void) {
    if (!s_iOSVM_initialized) return;

    Console.WriteLn("[BionicSX2] iOSVM_Shutdown");
    SysMemory::Release();
    s_iOSVM_initialized = false;
}

} // extern "C"