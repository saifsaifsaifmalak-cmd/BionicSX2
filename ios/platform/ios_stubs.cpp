// ios_stubs.cpp — Phase 4 stubs for unused subsystems
//
// This file provides stub definitions for PCSX2 globals and functions
// that are referenced but not implemented for iOS interpreter-only build.
// Each stub is marked with the Phase that will implement the real version.

#include "common/Pcsx2Defs.h"
#include <cstddef>
#include <cstdio>
#include <cstring>

#if defined(PCSX2_TARGET_IOS)

// Forward declarations - types defined in PCSX2 headers
class InputRecording;
class MemoryCardProtocol;
class MultitapProtocol;
class SymbolGuardian;
class SymbolImporter;

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
// Use pointer to avoid incomplete type error
MultitapProtocol* g_MultitapArr[4] = {};

// g_last_sector_block_lsn — CDVD disc reader variable (TODO Phase 7)
u32 g_last_sector_block_lsn = 0;

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

// libzip stubs — TODO Phase 4b: build libzip or guard CDVD callers
// These stubs satisfy the linker but return error codes

struct zip_t { int dummy; };
struct zip_error_t { int code; char msg[256]; };
struct zip_source_t { int dummy; };
struct zip_stat_t { u64 valid; const char* name; };

int zip_close(zip_t*) { return -1; }
void zip_discard(zip_t*) {}
int zip_error_code_zip(zip_error_t*) { return 0; }
const char* zip_error_strerror(zip_error_t*) { return "libzip not available"; }
int zip_fclose(zip_source_t*) { return -1; }
zip_t* zip_add(zip_t*, const char*, zip_source_t*) { return nullptr; }
zip_source_t* zip_fopen(zip_t*, const char*) { return nullptr; }
zip_source_t* zip_fopen_index(zip_t*, u64, u32) { return nullptr; }
ssize_t zip_fread(zip_source_t*, void*, size_t) { return -1; }
zip_source_t* zip_name_locate(zip_t*, const char*, u32) { return nullptr; }
zip_t* zip_open_from_source(zip_source_t*, u32, zip_error_t*) { return nullptr; }
int zip_set_file_compression(zip_t*, int, int) { return -1; }
zip_source_t* zip_source_begin_write(zip_source_t*) { return nullptr; }
zip_source_t* zip_source_buffer(const void*, u64, u32, zip_error_t*) { return nullptr; }
zip_source_t* zip_source_buffer_create(const void*, u64, u32, zip_error_t*) { return nullptr; }
int zip_source_commit_write(zip_source_t*) { return -1; }
zip_source_t* zip_source_file_create(const char*, zip_error_t*) { return nullptr; }
void zip_source_free(zip_source_t*) {}
ssize_t zip_source_write(zip_source_t*, const void*, size_t) { return -1; }
int zip_stat_index(zip_t*, u64, u32, zip_stat_t*) { return -1; }
const char* zip_strerror(zip_t*) { return "libzip not available"; }

#endif // PCSX2_TARGET_IOS