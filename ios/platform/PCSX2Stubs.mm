// PCSX2Stubs.mm — C++ stub implementations for iOS linking
// Phase 6: Real VMManager boot - provides external symbols

#include <string>

// Type aliases for PCSX2 types
typedef unsigned int u32;
typedef unsigned long long u64;
typedef unsigned char u8;
typedef unsigned short u16;

namespace PCSX2 {
struct Pcsx2Config;
}

// Forward declarations to match PCSX2 headers
namespace GS {
enum class GSVideoMode : int;
enum class GS_VideoMode : int;
}

extern "C" {

// ── Debug symbols (DebugTools) ─────────────────────────────────────────────
void R3000SymbolGuardian(u32 pc, const char* name) {}
void R5900SymbolImporter(u32 pc, const char* name) {}

// ── DEV9 stubs (network adapter) ───────────────────────────────────────────
void DEV9shutdown() {}
void DEV9irqHandler() {}
void DEV9CheckChanges(const PCSX2::Pcsx2Config*) {}
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

// dVifUnpack stubs - template functions
namespace {
template <int idx>
void dVifUnpack(const u8* data, bool isFill) { (void)data; (void)isFill; }
}

// ── GS stubs (graphics synth) ───────────────────────────────────────────────
void gsSetVideoMode(GS::GS_VideoMode mode) { (void)mode; }
void gsPostVsyncStart() {}
void gsWrite64_page_00(u32 addr, u64 data) { (void)addr; (void)data; }
void gsWrite64_page_01(u32 addr, u64 data) { (void)addr; (void)data; }
void gsWrite64_generic(u32 addr, u64 data) { (void)addr; (void)data; }

// ── Metal GS device stub ───────────────────────────────────────────────────
extern "C++" {
class GSDevice;
GSDevice* MakeGSDeviceMTL() { return nullptr; }
}

// ── IOP BIOS stubs ───────────────────────────────────────────────────────────
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