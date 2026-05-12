// PCSX2Stubs.mm — iOS stubs for all undefined symbols
// Phase 6b: Complete stub implementation for VMManager::Initialize
#import <Foundation/Foundation.h>
#include <string>
#include <memory>
#include <optional>
#include <vector>
#include <span>
#include "BionicLogger.hpp"

#include "common/Pcsx2Defs.h"
#include "common/HostSys.h"
#include "pcsx2/SaveState.h"
#include "pcsx2/StateWrapper.h"
#include "pcsx2/Achievements.h"
#include "pcsx2/USB/USB.h"
// InputRecording.h - stub class provided below
#include "pcsx2/SPU2/spu2.h"
#include "pcsx2/GS/GS.h"
#include "GS.h"

// Type aliases
typedef unsigned int u32;
typedef unsigned long long u64;
typedef unsigned char u8;
typedef unsigned short u16;
typedef int s32;

// Forward declarations
class GSDevice;
class GSTexture;
class SettingsInterface;
class Error;
class ArchiveEntryList;
class SaveStateScreenshotData;
class StateWrapper;
class SettingsWrapper;
class SettingsWrapperFile;
class SaveStateWrapper;
class Pcsx2Config;
struct ControllerInfo;
struct InputBindingInfo;
struct SettingInfo;
struct ButtonData;

// Note: AudioBackend and AudioExpansionMode enums are now provided by SPU2 headers
// Do not redefine here - they conflict with real implementations

// ── DEV9 ────────────────────────────────────────────────────────────
void DEV9shutdown() {}
s32 DEV9open() { return 0; }
void DEV9close() {}
void DEV9irqHandler() {}
void DEV9CheckChanges(const Pcsx2Config&) {}
u8 DEV9read8(u32) { return 0; }
u16 DEV9read16(u32) { return 0; }
u32 DEV9read32(u32) { return 0; }
void DEV9write8(u32, u8) {}
void DEV9write16(u32, u16) {}
void DEV9write32(u32, u32) {}
void DEV9readDMA8Mem(u32*, int) {}
void DEV9writeDMA8Mem(u32*, int) {}

// ── USB ─────────────────────────────────────────────────────────────
void USBclose() {}
u8 USBread8(u32) { return 0; }
u16 USBread16(u32) { return 0; }
u32 USBread32(u32) { return 0; }
void USBwrite8(u32, u8) {}
void USBwrite16(u32, u16) {}
void USBwrite32(u32, u32) {}
void USBsetRAM(void*) {}

// ── gsIrq ───────────────────────────────────────────────────────────
void gsIrq() {}
void gsSetVideoMode(GS_VideoMode) {}
GS_VideoMode gsVideoMode = GS_VideoMode::Uninitialized;

// ── AbortWithMessage ───────────────────────────────────────────────
void AbortWithMessage(const char* msg) {
    BionicLogger::instance().log("FATAL", "PCSX2", msg ? msg : "Unknown abort");
    BionicLogger::instance().flush();
    abort();
}

// ── DEV9init stub ──────────────────────────────────────────────
s32 DEV9init() { return 0; }

// ── USBinit stub ──────────────────────────────────────────────
void USBinit() {}

// ── Threading ────────────────────────────────────────────────────────
namespace Threading {
    class KernelSemaphore {
    public:
        KernelSemaphore() {}
        ~KernelSemaphore() {}
        void Post() {}
        void Wait() {}
    };
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

// ── SharedMemoryMappingArea - provided by HostSys_iOS.cpp ─────────────

// ── FullscreenUI ───────────────────────────────────────────────────
namespace FullscreenUI {
    __attribute__((weak_import)) void OnVMDestroyed() {}
    void CheckForConfigChanges(const Pcsx2Config&) {}
    void OnVMStarted() {}
    bool Render() { return false; }
}

// Note: Achievements, SPU2, USB namespaces are now provided by their headers
// When SaveState.cpp is guarded, these compilation units ARE linked

// ── Achievements stubs (required by VMManager) ────────────────────────
namespace Achievements {
    void GameChanged(unsigned int, unsigned int) {}
    bool IsHardcoreModeActive() { return false; }
    void FrameUpdate() {}
    void OnVMPaused(bool) {}
    void UpdateSettings(const Pcsx2Config::AchievementsOptions&) {}
}

// ── SPU2 stubs (required by VMManager) ────────────────────────────────
namespace SPU2 {
    bool Open() { return true; }
    void Close() {}
}
void SPU2readDMA4Mem(u16*, u32) {}
void SPU2writeDMA4Mem(u16*, u32) {}
void SPU2readDMA7Mem(u16*, u32) {}
void SPU2writeDMA7Mem(u16*, u32) {}

// ── USB stubs (required by Pcsx2Config) ──────────────────────────────
namespace USB {
    std::string GetConfigSection(int) { return ""; }
    const char* DeviceTypeIndexToName(s32) { return nullptr; }
    s32 DeviceTypeNameToIndex(std::string_view) { return 0; }
    void CheckForConfigChanges(const void*) {}
}

// ── FullscreenUI::GameChanged stub ───────────────────────────────────
namespace FullscreenUI {
    void GameChanged(std::string title, std::string path, std::string serial, u32 disc_crc, u32 crc) {}
}

// ── GSCapture ───────────────────────────────────────────────────────
namespace GSCapture {
    void EndCapture() {}
    bool IsCapturing() { return false; }
    bool BeginCapture(float, int, float, std::string) { return false; }
    void DeliverVideoFrame(void*) {}
    std::string GetNextCaptureFileName() { return {}; }
    int GetSize() { return 0; }
    bool IsCapturingVideo() { return false; }
}

// ── GSTextureReplacements ───────────────────────────────────────────
namespace GSTextureReplacements {
    __attribute__((weak_import)) void GameChanged() {}
    void ReloadReplacementMap() {}
    void Shutdown() {}
    void UpdateConfig(void*) {}
}

// ── SaveStateSelectorUI ─────────────────────────────────────────────
namespace SaveStateSelectorUI {
    void Clear() {}
}

// ── GameDatabase ───────────────────────────────────────────────────
namespace GameDatabase {
    class GameEntry;
    const GameEntry* findGame(std::string_view) { return nullptr; }
}

// ── GameList ───────────────────────────────────────────────────────
namespace GameList {
    void AddPlayedTimeForSerial(const std::string&, long, long) {}
}

// Note: AudioStream namespace now provided by SPU2 headers - don't redefine
// Note: AudioStreamParameters class now provided by SPU2 headers - don't redefine
// Note: USB namespace functions now provided by USB.h - don't redefine

// ── InputRecording stubs ──────────────────────────────────────────
class InputRecording {
public:
    bool isActive() const { return false; }
    void stop() {}
    void incFrameCounter() {}
    u32 getFrameCounter() const { return 0; }
    void setStartingFrame(u32) {}
    u32 getStartingFrame() { return 0; }
};
InputRecording g_InputRecording;

// ── IOCtlSrc (macOS only - stubbed for iOS) ──────────────────────────
class IOCtlSrc {
public:
    ~IOCtlSrc() {}
};

// ── ImGuiManager stubs ──────────────────────────────────────────────
class ImGuiManager {
public:
    void Initialize() {}
    void Shutdown(bool) {}
    void ReloadFonts() {}
    void RequestScaleUpdate() {}
    bool HasSoftwareCursor(u32) { return false; }
};
ImGuiManager* g_imGuiManager = nullptr;

// ── GSPng ──────────────────────────────────────────────────────────
namespace GSPng {
    enum class Format : u8 { PNG = 0 };
    bool Save(GSPng::Format, const std::string&, const u8*, int, int, int, int, bool) { return false; }
}

// ── InputManager stubs ───────────────────────────────────────────────
namespace InputManager {
    std::string ConvertHostKeyboardCodeToString(u32) { return ""; }
    std::optional<u32> ConvertHostKeyboardStringToCode(std::string_view) { return std::nullopt; }
    void ReloadSources(SettingsInterface&, std::unique_lock<std::mutex>&) {}
    void ReloadBindings(SettingsInterface&, SettingsInterface&, SettingsInterface&, bool, bool) {}
    void SetPadVibrationIntensity(u32 port, float large, float small) {}
    void PauseVibration() {}
    void PollSources() {}
}

// ── SaveState stubs ────────────────────────────────────────────────
bool SaveState_ZipToDisk(std::unique_ptr<ArchiveEntryList>, std::unique_ptr<SaveStateScreenshotData>, const char*, Error*) { return false; }
std::unique_ptr<ArchiveEntryList> SaveState_DownloadState(Error* error) { return nullptr; }
std::unique_ptr<SaveStateScreenshotData> SaveState_SaveScreenshot() { return nullptr; }

// ── Host callbacks ──────────────────────────────────────────────────
namespace Host {
    void OnGameChanged(const std::string& title, const std::string& elf_override, const std::string& disc_path, const std::string& disc_serial, u32 disc_crc, u32 crc) {}
    void OnVMDestroyed() {}
    void OnSaveStateSaved(std::string_view) {}
    void OnVMStarted() {}
    void OnVMPaused() {}
    void OnVMResumed() {}
    void CheckForSettingsChanges(const Pcsx2Config&) {}
}

// ── GameDatabaseSchema::GameEntry ───────────────────────────────────
namespace GameDatabaseSchema {
    class GameEntry {
    public:
        void applyGameFixes(void* config, bool applyAuto) const {}
        void applyGSHardwareFixes(void* options) const {}
    };
}

// ── GS functions ──────────────────────────────────────────────────
void gsPostVsyncStart() {}
#include "GS.h"
u128 gsNonMirroredRead(u32) { return u128::zero(); }

// ── GSLocalMemory (via isa_native for single-ISA) ──────────────────
#include "GS/GSLocalMemory.h"
namespace isa_native {
    void GSLocalMemoryPopulateFunctions(GSLocalMemory&) {}
}
#include "GS/MultiISA.h"
namespace isa_native {
    GSRenderer* makeGSRendererSW(int) { return nullptr; }
}

// ── HostSys stubs ──────────────────────────────────────────────────
#include "common/HostSys.h"
namespace HostSys {
    void BeginCodeWrite() {}
    void EndCodeWrite() {}
    void FlushInstructionCache(void*, size_t) {}
    bool MemProtect(void*, size_t, const PageProtectionMode&) { return true; }
}
u64 GetAvailablePhysicalMemory() { return 512ULL * 1024 * 1024; }

// ── ShortSpin ──────────────────────────────────────────────────────
void ShortSpin() {}

// ── SPU2 ──────────────────────────────────────────────────────────
namespace SPU2 {
    void CheckForConfigChanges(const void*) {}
    void OnTargetSpeedChanged() {}
    void Reset(bool) {}
    void SetOutputPaused(bool) {}
}
u16 SPU2read(u32) { return 0; }
void SPU2write(u32, u16) {}
void SPU2async() {}

// ── DEV9 async ─────────────────────────────────────────────────────
void DEV9async(u32) {}

// ── USB async ──────────────────────────────────────────────────────
void USBasync(u32) {}
// ── PerformanceMetrics ───────────────────────────────────────────
namespace PerformanceMetrics {
    void Reset() {}
    void Update(bool, bool, bool) {}
    void OnGPUPresent(float) {}
    int GetInternalFPSMethod() { return 0; }
}

// ── Perf ─────────────────────────────────────────────────────────
namespace Perf {
    namespace Group {
        void RegisterPC(const void*, unsigned long, unsigned int) {}
    }
    int vif = 0;
}

// ── _Clocks ────────────────────────────────────────────────────────
u64 _lClocks = 0;

// ── Multitap ──────────────────────────────────────────────────────
int _g_MultitapArr = 0;

// ── _g_RealGSMem ───────────────────────────────────────────────────
// Real declaration: alignas(16) extern u8 g_RealGSMem[Ps2MemSize::GSregs];
// Must be an array, not a pointer — MTGS.cpp writes to PS2MEM_GS[i] = g_RealGSMem[i]
#include "MemoryTypes.h"
alignas(16) u8 g_RealGSMem[Ps2MemSize::GSregs] = {};

// ── Pad base class ─────────────────────────────────────────────────