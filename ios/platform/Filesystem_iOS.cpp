// BionicSX2 — iOS Filesystem Implementation
// Phase 2 implementation target
// iOS sandbox paths — NO assumptions from macOS or Android
// Reference: PCSX2 macOS Filesystem → path roots updated for iOS sandbox

#include <string>
#include <cstdlib>

// iOS Sandbox Directory Layout:
//
//   Documents/          ← User-visible files (ROMs, BIOS, saves)
//   Library/            ← App data (settings, cache)
//   Library/Caches/     ← Temporary cache (evictable by OS)
//   tmp/                ← Temporary files (cleared on relaunch)
//
// NEVER hardcode paths — always derive from NSSearchPathForDirectoriesInDomains
// or NSTemporaryDirectory() at runtime.
// These are implemented in Filesystem_iOS.mm (Objective-C++ required for NS APIs)

// TODO Phase 2: Move all path resolution to Filesystem_iOS.mm
// and expose via these C++ function signatures.

// Returns: iOS Documents directory (ROMs, BIOS, memory cards)
// Example: /var/mobile/Containers/Data/Application/<UUID>/Documents
std::string Filesystem_GetDocumentsPath() {
    // TODO Phase 2: implement in .mm using NSSearchPathForDirectoriesInDomains
    return "";
}

// Returns: iOS Library directory (settings, databases)
std::string Filesystem_GetLibraryPath() {
    // TODO Phase 2: implement in .mm using NSSearchPathForDirectoriesInDomains
    return "";
}

// Returns: iOS tmp directory (scratch space, cleared on relaunch)
std::string Filesystem_GetTempPath() {
    // TODO Phase 2: implement in .mm using NSTemporaryDirectory()
    return "";
}

// Returns: BIOS file path inside Documents/bios/
// BIOS must be user-supplied — cannot be bundled (legal requirement)
std::string Filesystem_GetBIOSPath(const std::string& filename) {
    // TODO Phase 2: GetDocumentsPath() + "/bios/" + filename
    return "";
}

// Returns: Memory card path inside Documents/memcards/
std::string Filesystem_GetMemCardPath(int slot) {
    // TODO Phase 2: GetDocumentsPath() + "/memcards/Mcd00" + slot + ".ps2"
    return "";
}

// Returns: Save state path inside Documents/sstates/
std::string Filesystem_GetSaveStatePath(const std::string& serial, int slot) {
    // TODO Phase 2: GetDocumentsPath() + "/sstates/" + serial + "_" + slot + ".p2s"
    return "";
}
