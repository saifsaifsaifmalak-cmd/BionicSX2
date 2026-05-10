// PCSX2Stubs.mm — Stub implementations for iOS linking
// Provides minimal stubs to satisfy linker for Phase 6

#include "common/Pcsx2Types.h"
#include "GS/GS.h"
#include "Config.h"
#include "GS/Renderers/Metal/GSMetalCPPAccessible.h"

// ── Debug symbols (DebugTools) ─────────────────────────────────────────────
void R3000SymbolGuardian(u32 pc, const char* name) {}
void R5900SymbolImporter(u32 pc, const char* name) {}

// ── DEV9 stubs (network adapter) ───────────────────────────────────────────
extern "C" {
void DEV9shutdown() {}
void DEV9irqHandler() {}
void DEV9CheckChanges(const Pcsx2Config&) {}
u8 DEV9read8(u32 addr) { (void)addr; return 0; }
u16 DEV9read16(u32 addr) { (void)addr; return 0; }
u32 DEV9read32(u32 addr) { (void)addr; return 0; }
void DEV9write8(u32 addr, u8 val) { (void)addr; (void)val; }
void DEV9write16(u32 addr, u16 val) { (void)addr; (void)val; }
void DEV9write32(u32 addr, u32 val) { (void)addr; (void)val; }

// ── CDVD stubs (disc drive) ─────────────────────────────────────────────────
void cdvdStartThread() {}
void cdvdStopThread() {}
void cdvdRequestSector(u32 lsn, int retry) { (void)lsn; (void)retry; }
int cdvdGetSector(u32 lsn, int mode) { (void)lsn; (void)mode; return 0; }
void cdvdRefreshData() {}
bool GetValidDrive(std::string& filename) { (void)filename; return false; }

// ── VIF stubs ───────────────────────────────────────────────────────────────
void PGIFrQword(u32 addr, void* data) { (void)addr; (void)data; }
void PGIFwQword(u32 addr, void* data) { (void)addr; (void)data; }
} // extern "C"

void dVifUnpack<0>(const u8* data, bool isstatic) { (void)data; (void)isstatic; }
void dVifUnpack<1>(const u8* data, bool isstatic) { (void)data; (void)isstatic; }

// ── GS stubs (graphics synth) ───────────────────────────────────────────────
extern "C" {
void gsSetVideoMode(GSVideoMode mode) { (void)mode; }
void gsPostVsyncStart() {}
void gsWrite64_page_00(u32 addr, u64 data) { (void)addr; (void)data; }
void gsWrite64_page_01(u32 addr, u64 data) { (void)addr; (void)data; }
void gsWrite64_generic(u32 addr, u64 data) { (void)addr; (void)data; }
} // extern "C"

// ── Metal GS device stub ───────────────────────────────────────────────────
GSDevice* MakeGSDeviceMTL() {
    return nullptr;
}

// ── IOP BIOS stubs ───────────────────────────────────────────────────────────
extern "C" {
void psxBiosReset() {}
void psxBiosCall() {}

// ── Timing stubs ─────────────────────────────────────────────────────────────
u64 GetCPUTicks() { return 0; }
u64 GetTickFrequency() { return 1000000000; }

// ── Error handling stub ─────────────────────────────────────────────────────
void AbortWithMessage(const char* msg) {
    (void)msg;
    __builtin_trap();
}
} // extern "C"