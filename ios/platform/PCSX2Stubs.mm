// PCSX2Stubs.mm — iOS stubs for unimplemented subsystems
// Phase 6: Stubs all undefined symbols to get build passing

#import <Foundation/Foundation.h>
#include <string>
#include <memory>

// Type aliases
typedef unsigned int u32;
typedef unsigned long long u64;
typedef unsigned char u8;
typedef unsigned short u16;

namespace PCSX2 { struct Pcsx2Config; }
namespace GS { enum class GS_VideoMode : int; }

extern "C" {

// ── DEV9 — PS2 expansion port ─────────────────────────────────────────────
void DEV9shutdown() {}
void DEV9close() {}
void DEV9irqHandler() {}
void DEV9CheckChanges(const PCSX2::Pcsx2Config*) {}
u8 DEV9read8(u32 addr) { (void)addr; return 0; }
u16 DEV9read16(u32 addr) { (void)addr; return 0; }
u32 DEV9read32(u32 addr) { (void)addr; return 0; }
void DEV9write8(u32 addr, u8 val) { (void)addr; (void)val; }
void DEV9write16(u32 addr, u16 val) { (void)addr; (void)val; }
void DEV9write32(u32 addr, u32 val) { (void)addr; (void)val; }

// ── USB — PS2 USB controller ─────────────────────────────────────────────
void USBclose() {}

// ── gsIrq ──────────────────────────────────────────────────────────────────
void gsIrq() {}

// ── AbortWithMessage ─────────────────────────────────────────────────────
void AbortWithMessage(const char* msg) {
    NSLog(@"[BionicSX2] ABORT: %s", msg ? msg : "unknown");
    abort();
}

} // extern "C"

// ── FullscreenUI stubs ───────────────────────────────────────────────────
namespace FullscreenUI {
    void GameChanged(const std::string&, const std::string&, const std::string&, u32, u32) {}
    void OnVMDestroyed() {}
}

// ── SaveStateSelectorUI stub ─────────────────────────────────────────────
namespace SaveStateSelectorUI {
    void Clear() {}
}

// ── Achievements stubs ───────────────────────────────────────────────────
namespace Achievements {
    void GameChanged(u32, u32) {}
    bool IsHardcoreModeActive() { return false; }
}

// ── GSCapture stubs ─────────────────────────────────────────────────────
namespace GSCapture {
    void EndCapture() {}
    bool IsCapturing() { return false; }
}

// ── GSTextureReplacements stub ──────────────────────────────────────────
namespace GSTextureReplacements {
    void GameChanged() {}
}

// ── GameDatabase stubs ───────────────────────────────────────────────────
namespace GameDatabase {
    class GameEntry;
    const GameEntry* findGame(std::string_view) { return nullptr; }
}
namespace GameDatabaseSchema {
    class GameEntry {
    public:
        void applyGSHardwareFixes(class Pcsx2Config::GSOptions&) const {}
        void applyGameFixes(class Pcsx2Config&, bool) const {}
    };
}

// ── GameList stub ───────────────────────────────────────────────────────
namespace GameList {
    void AddPlayedTimeForSerial(const std::string&, long, long) {}
}

// ── Common::InhibitScreensaver ───────────────────────────────────────────
namespace Common {
    void InhibitScreensaver(bool) {
        // iOS handles this via UIApplication
    }
}

// ── SharedMemoryMappingArea stub ─────────────────────────────────────────
class SharedMemoryMappingArea {
public:
    SharedMemoryMappingArea() {}
    ~SharedMemoryMappingArea() {}
    void Unmap(void* addr, u64 size, bool) { (void)addr; (void)size; }
};

// ── Threading::KernelSemaphore stub ──────────────────────────────────────
namespace Threading {
    class KernelSemaphore {
    public:
        KernelSemaphore() {}
        ~KernelSemaphore() {}
        void Post() {}
        void Wait() {}
    };
}

// ── Threading::Thread stubs ──────────────────────────────────────────────
namespace Threading {
    class Thread {
    public:
        Thread() {}
        ~Thread() {}
        void Join() {}
    };
    class ThreadHandle {
    public:
        ThreadHandle() {}
        ~ThreadHandle() {}
        void SetAffinity(unsigned long long) {}
    };
}

// ── USB stubs ───────────────────────────────────────────────────────────
namespace USB {
    const char* GetConfigSection(int) { return nullptr; }
    const char* DeviceTypeIndexToName(int) { return nullptr; }
    int DeviceTypeNameToIndex(std::string_view) { return 0; }
}

// ── InputRecording stubs ───────────────────────────────────────────────
namespace InputRecording {
    bool isActive() { return false; }
    void stop() {}
}
bool g_InputRecording = false;

// ── Memory stub ─────────────────────────────────────────────────────────
unsigned char* g_RealGSMem = nullptr;

// ── gsIrq declaration for GS ─────────────────────────────────────────────
extern "C" {
void gsIrq();
}