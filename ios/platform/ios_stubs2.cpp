// ios_stubs2.cpp — Additional Phase 5 stubs for linked pcsx2_core
// Minimal stubs to satisfy linker after pcsx2_core is linked

#include "common/Pcsx2Defs.h"

#if defined(PCSX2_TARGET_IOS)

// Just provide bare minimum extern "C" stubs - no class/struct definitions
// to avoid conflicts with the actual library

extern "C" {

// Character conversion stub (simple C impl)
const char* ShiftJIS_ConvertString(const char* input) {
    return input;
}

// GS write stubs (simple C implementations)
void gsWrite64_generic(unsigned int addr, unsigned long long value) { }
void gsWrite64_page_00(unsigned int addr, unsigned long long value) { }
void gsWrite64_page_01(unsigned int addr, unsigned long long value) { }

// CDVD stub
int GetValidDrive(void* path) { return 0; }

} // extern "C"