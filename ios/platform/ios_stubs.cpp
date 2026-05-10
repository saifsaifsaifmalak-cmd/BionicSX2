// ios_stubs.cpp — Phase 4 stubs for unused subsystems
//
// This file provides stub definitions for PCSX2 globals and functions
// that are referenced but not implemented for iOS interpreter-only build.
// Each stub is marked with the Phase that will implement the real version.

#include "common/Pcsx2Defs.h"
#include "pcsx2/pcsx2/Recording/InputRecording.h"
#include "pcsx2/pcsx2/GS.h"
#include "pcsx2/pcsx2/SIO/Memcard/MemoryCardProtocol.h"
#include "pcsx2/pcsx2/SIO/Multitap/MultitapProtocol.h"
#include "pcsx2/pcsx2/DebugTools/SymbolGuardian.h"
#include "pcsx2/pcsx2/DebugTools/SymbolImporter.h"
#include "pcsx2/pcsx2/DEV9/DEV9.h"

#if defined(PCSX2_TARGET_IOS)

// g_InputRecording — Input recording/playing (TODO Phase 6)
InputRecording g_InputRecording;

// g_RealGSMem — GS registers (TODO Phase 5: Metal renderer)
alignas(16) u8 g_RealGSMem[Ps2MemSize::GSregs] = {};

// g_MemoryCardProtocol — Memory cardprotocol (TODO Phase 7)
MemoryCardProtocol g_MemoryCardProtocol;

// g_MultitapArr — Multitap controller protocol (TODO Phase 7)
std::array<MultitapProtocol, SIO::PORTS> g_MultitapArr;

// R3000SymbolGuardian — MIPS symbol database (TODO: not needed for interpreter)
SymbolGuardian R3000SymbolGuardian;

// R5900SymbolImporter — ELF symbol importer (TODO: not needed for interpreter)
SymbolImporter R5900SymbolImporter;

// DEV9 stubs — PS2 expansion port peripheral (TODO Phase 7)
u8 DEV9read8(u32 addr) { return 0; }
u16 DEV9read16(u32 addr) { return 0; }
u32 DEV9read32(u32 addr) { return 0; }
void DEV9write8(u32 addr, u8 value) { (void)addr; (void)value; }
void DEV9write16(u32 addr, u16 value) { (void)addr; (void)value; }
void DEV9write32(u32 addr, u32 value) { (void)addr; (void)value; }

#endif // PCSX2_TARGET_IOS