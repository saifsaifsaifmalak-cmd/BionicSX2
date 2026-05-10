// PCSX2Stubs.c — Pure C stub implementations for iOS linking
// Provides minimal stubs to satisfy linker for Phase 6

#include <stdint.h>
#include <stdbool.h>

typedef uint32_t u32;
typedef uint64_t u64;
typedef uint8_t u8;
typedef uint16_t u16;

// ── Debug symbols (DebugTools) ─────────────────────────────────────────────
void R3000SymbolGuardian(u32 pc, const char* name) {(void)pc;(void)name;}
void R5900SymbolImporter(u32 pc, const char* name) {(void)pc;(void)name;}

// ── DEV9 stubs (network adapter) ───────────────────────────────────────────
void DEV9shutdown(void) {}
void DEV9irqHandler(void) {}
void DEV9CheckChanges(const void* config) {(void)config;}
u8 DEV9read8(u32 addr) {(void)addr; return 0;}
u16 DEV9read16(u32 addr) {(void)addr; return 0;}
u32 DEV9read32(u32 addr) {(void)addr; return 0;}
void DEV9write8(u32 addr, u8 val) {(void)addr;(void)val;}
void DEV9write16(u32 addr, u16 val) {(void)addr;(void)val;}
void DEV9write32(u32 addr, u32 val) {(void)addr;(void)val;}

// ── CDVD stubs (disc drive) ─────────────────────────────────────────────────
void cdvdStartThread(void) {}
void cdvdStopThread(void) {}
void cdvdRequestSector(u32 lsn, int retry) {(void)lsn;(void)retry;}
int cdvdGetSector(u32 lsn, int mode) {(void)lsn;(void)mode; return 0;}
void cdvdRefreshData(void) {}
bool GetValidDrive(void* filename) {(void)filename; return false;}

// ── VIF stubs ───────────────────────────────────────────────────────────────
void PGIFrQword(u32 addr, void* data) {(void)addr;(void)data;}
void PGIFwQword(u32 addr, void* data) {(void)addr;(void)data;}
void dVifUnpack0(const u8* data, bool isFill) {(void)data;(void)isFill;}
void dVifUnpack1(const u8* data, bool isFill) {(void)data;(void)isFill;}

// ── GS stubs (graphics synth) ───────────────────────────────────────────────
void gsSetVideoMode(int mode) {(void)mode;}
void gsPostVsyncStart(void) {}
void gsWrite64_page_00(u32 addr, u64 data) {(void)addr;(void)data;}
void gsWrite64_page_01(u32 addr, u64 data) {(void)addr;(void)data;}
void gsWrite64_generic(u32 addr, u64 data) {(void)addr;(void)data;}

// ── IOP BIOS stubs ───────────────────────────────────────────────────────────
void psxBiosReset(void) {}
void psxBiosCall(void) {}

// ── Timing stubs ─────────────────────────────────────────────────────────────
u64 GetCPUTicks(void) {return 0;}
u64 GetTickFrequency(void) {return 1000000000;}

// ── Error handling stub ─────────────────────────────────────────────────────
void AbortWithMessage(const char* msg) {(void)msg;__builtin_trap();}