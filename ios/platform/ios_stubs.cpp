// ios_stubs.cpp — Phase 4 stubs for unused subsystems
//
// This file provides stub definitions for PCSX2 globals and functions
// that are referenced but not implemented for iOS interpreter-only build.
// Each stub is marked with the Phase that will implement the real version.

#include "common/Pcsx2Defs.h"
#include <array>

#if defined(PCSX2_TARGET_IOS)

// Forward declarations - types defined in PCSX2 headers
class InputRecording;
class MemoryCardProtocol;
class MultitapProtocol;
class SymbolGuardian;
class SymbolImporter;

namespace SIO { enum : int { PORTS = 4 }; }

// g_InputRecording — Input recording/playing (TODO Phase 6)
class InputRecording {};
InputRecording g_InputRecording;

// g_RealGSMem — GS registers (TODO Phase 5: Metal renderer)
// Size matches Ps2MemSize::GSregs (0x4000 = 16KB)
alignas(16) u8 g_RealGSMem[0x4000] = {};

// g_MemoryCardProtocol — Memory card protocol (TODO Phase 7)
class MemoryCardProtocol {};
MemoryCardProtocol g_MemoryCardProtocol;

// g_MultitapArr — Multitap controller protocol (TODO Phase 7)
std::array<MultitapProtocol, 4> g_MultitapArr;

// R3000SymbolGuardian — MIPS symbol database (TODO: not needed for interpreter)
class SymbolGuardian {};
SymbolGuardian R3000SymbolGuardian;

// R5900SymbolImporter — ELF symbol importer (TODO: not needed for interpreter)
class SymbolImporter {};
SymbolImporter R5900SymbolImporter;

// DEV9 stubs — PS2 expansion port peripheral (TODO Phase 7)
u8 DEV9read8(u32 addr) { return 0; }
u16 DEV9read16(u32 addr) { return 0; }
u32 DEV9read32(u32 addr) { return 0; }
void DEV9write8(u32 addr, u8 value) { (void)addr; (void)value; }
void DEV9write16(u32 addr, u16 value) { (void)addr; (void)value; }
void DEV9write32(u32 addr, u32 value) { (void)addr; (void)value; }

#endif // PCSX2_TARGET_IOS