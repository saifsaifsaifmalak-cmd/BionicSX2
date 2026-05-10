// PCSX2Stubs.mm — Stub implementations for iOS linking
// Provides minimal stubs to satisfy linker for Phase 6
// These are Phase 5 work - will be replaced with real implementations

#include "common/Pcsx2Types.h"
#include "GS/GS.h"

extern "C" {

// ── Debug symbols (DebugTools) ─────────────────────────────────────────────
void R3000SymbolGuardian(u32 pc, const char* name) {}
void R5900SymbolImporter(u32 pc, const char* name) {}

// ── DEV9 stubs (network adapter) ───────────────────────────────────────────
void DEV9shutdown() {}
void DEV9irqHandler() {}
void DEV9CheckChanges(const struct Pcsx2Config&) {}
u8 DEV9read8(u32 addr) { return 0; }
u16 DEV9read16(u32 addr) { return 0; }
u32 DEV9read32(u32 addr) { return 0; }
void DEV9write8(u32 addr, u8 val) {}
void DEV9write16(u32 addr, u16 val) {}
void DEV9write32(u32 addr, u32 val) {}

// ── CDVD stubs (disc drive) ─────────────────────────────────────────────────
void cdvdStartThread() {}
void cdvdStopThread() {}
void cdvdRequestSector(u32 lsn, int retry) {}
void cdvdGetSector(u32 lsn, int mode) { return 0; }
void cdvdRefreshData() {}
bool GetValidDrive(std::string& filename) { return false; }

// ── GS stubs (graphics synth) ────────────────────────────────────────────────
void gsSetVideoMode(GS_VideoMode mode) {}
void gsPostVsyncStart() {}
void gsWrite64_page_00(u32 addr, u64 data) {}
void gsWrite64_generic(u32 addr, u64 data) {}

// ── VIF stubs ────────────────────────────────────────────────────────────────
void PGIFrQword(u32 addr, void* data) {}
void PGIFwQword(u32 addr, void* data) {}
void dVifUnpack0(const u8* data, bool isstatic) {}
void dVifUnpack1(const u8* data, bool isstatic) {}

// ── IOP BIOS stubs ───────────────────────────────────────────────────────────
void psxBiosReset() {}
void psxBiosCall() {}

// ── Timing stubs ─────────────────────────────────────────────────────────────
u64 GetCPUTicks() { return 0; }
u64 GetTickFrequency() { return 1000000000; }

// ── Error handling stub ─────────────────────────────────────────────────────
void AbortWithMessage(const char* msg) {
    __builtin_trap();
}

} // extern "C"