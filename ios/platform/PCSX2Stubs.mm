// PCSX2Stubs.mm — iOS stubs for all undefined symbols
// Phase 6b: Complete stub implementation for VMManager::Initialize
#import <Foundation/Foundation.h>
#include <string>
#include <memory>
#include <optional>
#include <vector>
#include <span>

#include "common/Pcsx2Defs.h"
#include "common/HostSys.h"

// Type aliases
typedef unsigned int u32;
typedef unsigned long long u64;
typedef unsigned char u8;
typedef unsigned short u16;
typedef int s32;

// Forward declarations
class GSDevice;
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

enum class AudioBackend { Null = 0, Cubeb, SDL, Count };
enum class AudioExpansionMode { Disabled = 0, StereoLFE, Quadraphonic, QuadraphonicLFE, Surround51, Surround71, Count };

// ── DEV9 ────────────────────────────────────────────────────────────
void DEV9shutdown() {}
s32 DEV9open() { return 0; }
void DEV9close() {}

// ── USB ─────────────────────────────────────────────────────────────
void USBclose() {}

// ── gsIrq ───────────────────────────────────────────────────────────
void gsIrq() {}

// ── AbortWithMessage ───────────────────────────────────────────────
void AbortWithMessage(const char* msg) {
    NSLog(@"[BionicSX2] ABORT: %s", msg ? msg : "(null)");
    abort();
}

// ── MakeGSDeviceMTL ───────────────────────────────────────────────
GSDevice* MakeGSDeviceMTL() { return nullptr; }

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
}

// ── Achievements ───────────────────────────────────────────────────
namespace Achievements {
    __attribute__((weak_import)) void GameChanged(unsigned int, unsigned int) {}
    __attribute__((weak_import)) bool IsHardcoreModeActive() { return false; }
}

// ── GSCapture ───────────────────────────────────────────────────────
namespace GSCapture {
    void EndCapture() {}
    bool IsCapturing() { return false; }
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

// ── AudioStream stubs (minimal — SPU2 audio deferred) ──────────────
namespace AudioStream {
    const char* GetBackendName(int) { return "Null"; }
    std::optional<AudioBackend> ParseBackendName(const char*) { return std::nullopt; }
    const char* GetBackendDisplayName(AudioBackend) { return "Null (No Output)"; }
    const char* GetExpansionModeName(AudioExpansionMode) { return "Disabled"; }
    const char* GetExpansionModeDisplayName(AudioExpansionMode) { return "Disabled (Stereo)"; }
    std::optional<AudioExpansionMode> ParseExpansionMode(const char*) { return std::nullopt; }
}

// ── AudioStreamParameters ───────────────────────────────────────────
class AudioStreamParameters {
public:
    void LoadSave(SettingsWrapper&, const char*) {}
    static constexpr AudioExpansionMode DEFAULT_EXPANSION_MODE = AudioExpansionMode::Disabled;
    static constexpr bool DEFAULT_OUTPUT_LATENCY_MINIMAL = false;
    static constexpr u16 DEFAULT_BUFFER_MS = 512;
    static constexpr u16 DEFAULT_OUTPUT_LATENCY_MS = 192;
};

// ── USB extended stubs ─────────────────────────────────────────────
namespace USB {
    const char* GetConfigSection(int) { return nullptr; }
    const char* DeviceTypeIndexToName(s32) { return nullptr; }
    s32 DeviceTypeNameToIndex(std::string_view) { return 0; }
    std::vector<std::pair<const char*, const char*>> GetDeviceTypes() { return {}; }
    const char* GetConfigDevice(const SettingsInterface&, u32) { return nullptr; }
    std::string GetConfigSubKey(std::string_view, std::string_view) { return ""; }
    u32 GetConfigSubType(const SettingsInterface&, u32, std::string_view) { return 0; }
    void GetDeviceBindings(std::string_view, u32) {}
    void SetDeviceBindValue(u32, u32, float) {}
}

// ── InputRecording stubs ──────────────────────────────────────────
namespace InputRecording {
    bool isActive() { return false; }
    void stop() {}
}
bool g_InputRecording = false;

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

class GSRendererHW { public: GSRendererHW() {} };
class GSRendererNull { public: GSRendererNull() {} };
class GSDrawingContext {
public:
    void Dump(const std::string&) const {}
    void UpdateScissor() {}
};
class GSDrawingEnvironment {
public:
    void Dump(const std::string&) const {}
};

// ── GSPng ──────────────────────────────────────────────────────────
namespace GSPng {
    bool Save(int, const std::string&, const u8*, int, int, int, int, bool) { return false; }
}

// ── InputManager stubs ───────────────────────────────────────────────
namespace InputManager {
    std::string ConvertHostKeyboardCodeToString(u32) { return ""; }
    std::optional<u32> ConvertHostKeyboardStringToCode(std::string_view) { return std::nullopt; }
}

// ── SaveState stubs ────────────────────────────────────────────────
void SaveState_ZipToDisk(std::unique_ptr<ArchiveEntryList>, std::unique_ptr<SaveStateScreenshotData>, const char*, Error*) {}
void SaveState_DownloadState(Error*) {}
void SaveState_SaveScreenshot() {}

// ── FullscreenUI::GameChanged ───────────────────────────────────────
namespace FullscreenUI {
    void GameChanged(std::string title, std::string path, std::string serial, u32 disc_crc, u32 crc) {}
}

// ── Host callbacks ──────────────────────────────────────────────────
namespace Host {
    void OnGameChanged(const std::string& title, const std::string& elf_override, const std::string& disc_path, const std::string& disc_serial, u32 disc_crc, u32 crc) {}
    void OnVMDestroyed() {}
    void OnSaveStateSaved(std::string_view path) {}
}

// ── GameDatabaseSchema::GameEntry ───────────────────────────────────
namespace GameDatabaseSchema {
    class GameEntry {
    public:
        void applyGameFixes(void* config, bool applyAuto) const {}
        void applyGSHardwareFixes(void* options) const {}
    };
}

// ── iOS stub: AudioStream::GetBackendName ───────────────────────
const char* AudioStream::GetBackendName(AudioBackend backend)
{
    switch (backend) {
        case AudioBackend::Null: return "Null";
        case AudioBackend::Cubeb: return "Cubeb";
        case AudioBackend::SDL: return "SDL";
        default: return "Unknown";
    }
}

// ── iOS stub: AudioStreamParameters::LoadSave ─────────────────
void AudioStreamParameters::LoadSave(SettingsWrapper& wrap, const char* section)
{
    // Phase 5: no persistence needed
}

// ── _g_RealGSMem ───────────────────────────────────────────────────
u8* g_RealGSMem = nullptr;

// ── InputManager stubs ─────────────────────────────────────────────
namespace InputManager {
    void ReloadSources(SettingsInterface&, std::unique_lock<std::mutex>&) {}
    void ReloadBindings(SettingsInterface&, SettingsInterface&, SettingsInterface&, bool, bool) {}
    void SetPadVibrationIntensity(u32 port, float large, float small) {}
}

// ── Pad base class ─────────────────────────────────────────────────