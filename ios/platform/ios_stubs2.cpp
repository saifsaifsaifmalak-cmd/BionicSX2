// ios_stubs2.cpp — Additional Phase 5 stubs for linked pcsx2_core
// Added because linking pcsx2_core exposes more symbols from full PCSX2

#include "common/Pcsx2Defs.h"
#include "GS/GS.h"
#include "Recording/InputRecording.h"
#include "SIO/Memcard/MemoryCardProtocol.h"
#include "SIO/Multitap/MultitapProtocol.h"
#include "DEV9/DEV9.h"
#include "DebugTools/SymbolGuardian.h"
#include "DebugTools/SymbolImporter.h"
#include <array>
#include <cstring>

#if defined(PCSX2_TARGET_IOS)

// DebugTools stubs (from SymbolGuardian.cpp / SymbolImporter.cpp - removed from build)
SymbolGuardian R3000SymbolGuardian;
SymbolImporter R5900SymbolImporter;

// GS registers stub (16KB matching Ps2MemSize::GSregs)
alignas(16) u8 g_RealGSMem[0x4000] = {};

// GS video mode stub
void gsSetVideoMode(GS_VideoMode mode) { (void)mode; }

// GS write stubs
void gsWrite64_generic(u32 addr, u64 value) { (void)addr; (void)value; }
void gsWrite64_page_00(u32 addr, u64 value) { (void)addr; (void)value; }
void gsWrite64_page_01(u32 addr, u64 value) { (void)addr; (void)value; }
void gsWrite128_generic(u32 addr, u32 value) { (void)addr; (void)value; }
void gsWrite128_page_00(u32 addr, u32 value) { (void)addr; (void)value; }
void gsWrite128_page_01(u32 addr, u32 value) { (void)addr; (void)value; }

// InputRecording stub
InputRecording g_InputRecording;

// Memory card stub
MemoryCardProtocol g_MemoryCardProtocol;

// Multitap stub
MultitapProtocol* g_MultitapArr[4] = {};

// DEV9 stubs
u8 DEV9read8(u32 addr) { return 0; }
u16 DEV9read16(u32 addr) { return 0; }
u32 DEV9read32(u32 addr) { return 0; }
void DEV9write8(u32 addr, u8 value) { (void)addr; (void)value; }
void DEV9write16(u32 addr, u16 value) { (void)addr; (void)value; }
void DEV9write32(u32 addr, u32 value) { (void)addr; (void)value; }

// CDVD stub
int GetValidDrive(std::string& path) {
    return 0;  // Return 0 = not found
}

// SaveState stubs (SaveState.cpp was removed from build but referenced)
class ArchiveEntryList {};
class SaveStateScreenshotData {};
int SaveState_ZipToDisk(
    std::unique_ptr<ArchiveEntryList>,
    std::unique_ptr<SaveStateScreenshotData>,
    const char*, Error*) {
    return -1;
}
void SaveState_DownloadState(Error*) {}
int SaveState_UnzipFromDisk(const std::string&, Error*) {
    return -1;
}
void SaveState_SaveScreenshot() {}
void SaveState_ReportLoadErrorOSD(const std::string&, const std::optional<int>, bool) {}
void SaveState_ReportSaveErrorOSD(const std::string&, const std::optional<int>) {}

// Character conversion stub
std::string ShiftJIS_ConvertString(const char* input) {
    return input ? std::string(input) : std::string();
}
std::string ShiftJIS_ConvertString(const char* input, int len) {
    if (!input) return std::string();
    return std::string(input, len > 0 ? len : (int)strlen(input));
}

// GSVector4i static member
u8 GSVector4i::m_x0f = 0;

// ISA native makeGSRendererSW stub
namespace isa_native {
    GSRenderer* makeGSRendererSW(int threads) { return nullptr; }
}

#endif // PCSX2_TARGET_IOS