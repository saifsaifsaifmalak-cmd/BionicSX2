// PCSX2Stubs.mm — iOS stubs for all undefined symbols
// Phase 6b: Complete stub implementation for VMManager::Initialize
#import <Foundation/Foundation.h>
#include <string>
#include <memory>
#include <optional>
#include <vector>
#include <span>

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

// Forward declare nested types
namespace Pcsx2Config {
    class GSOptions;
}

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

// ── SharedMemoryMappingArea ─────────────────────────────────────────
class SharedMemoryMappingArea {
public:
    SharedMemoryMappingArea() {}
    ~SharedMemoryMappingArea() {}
    void Unmap(void* addr, u64 size, bool) {}
};

// ── InputRecording ──────────────────────────────────────────────────
namespace InputRecording {
    bool isActive() { return false; }
    void stop() {}
}
bool g_InputRecording = false;

// ── Hotkey globals ─────────────────────────────────────────────────
struct HotkeyInfo {
    const char* name;
    const char* category;
    const char* display_name;
    void (*handler)(s32 pressed);
};

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

// ── AudioStream ───────────────────────────────────────────────────
namespace AudioStream {
    const char* GetBackendName(int) { return "Null"; }
    int ParseBackendName(const char*) { return 0; }
}

// ── AudioStreamParameters ───────────────────────────────────────────
class AudioStreamParameters {
public:
    void LoadSave(SettingsWrapper&, const char*) {}
};

// ── Common::InhibitScreensaver ───────────────────────────────────────
namespace Common {
    void InhibitScreensaver(bool) {}
}

// ── USB extended stubs ─────────────────────────────────────────────
namespace USB {
    const char* GetConfigSection(int) { return nullptr; }
    const char* DeviceTypeIndexToName(s32) { return nullptr; }
    s32 DeviceTypeNameToIndex(std::string_view) { return 0; }
    std::vector<std::pair<const char*, const char*>> GetDeviceTypes() { return {}; }
    const char* GetConfigDevice(const SettingsInterface&, u32) { return nullptr; }
    const char* GetConfigSubKey(std::string_view, std::string_view) { return nullptr; }
    const char* GetConfigSubType(const SettingsInterface&, u32, std::string_view) { return nullptr; }
    void GetDeviceBindings(std::string_view, u32) {}
    void SetDeviceBindValue(u32, u32, float) {}
}

// ── Host callbacks (only those NOT in Host_iOS.mm) ──────────────────
namespace Host {
    void ReleaseRenderWindow() {}
    void SetMouseMode(bool, bool) {}
}

// ── ImGuiManager ───────────────────────────────────────────────────
class ImGuiManager {
public:
    void Initialize() {}
    void Shutdown(bool) {}
    void ReloadFonts() {}
    void RequestScaleUpdate() {}
    bool HasSoftwareCursor(u32) { return false; }
};
ImGuiManager* g_imGuiManager = nullptr;

// ── GS classes ─────────────────────────────────────────────────────
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

// ── IOCtlSrc ───────────────────────────────────────────────────────
class IOCtlSrc {
public:
    ~IOCtlSrc() {}
};

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
        void applyGameFixes(Pcsx2Config& config, bool applyAuto) const {}
        void applyGSHardwareFixes(Pcsx2Config::GSOptions& options) const {}
    };
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
class PadBase {
public:
    PadBase(u8, u64) {}
    virtual ~PadBase() {}
    virtual void Freeze(StateWrapper&, bool) {}
    virtual void SetMode(u32) {}
    virtual std::string GetEffect(u32) const { return ""; }
    virtual void SetEffect(u32, std::string_view) {}
    virtual void GetButtonState(ButtonData*) const {}
    virtual void SetButtonState(ButtonData*) {}
    virtual void SetAxisState(u32, float, float) {}
    virtual void SetDPadState(u32) {}
    virtual float Get(u32, float) const { return 0.0f; }
    virtual void Set(u32, float) {}
    virtual void QueueDmaTransfer(u32, u32, u32, u32, u32, u32) {}
    virtual void StartDma() {}
    virtual void StopDma() {}
    virtual bool IsDmaRunning() const { return false; }
    virtual void ResetDma() {}
    virtual void SetButton(u32) {}
    virtual void UnsetButton(u32) {}
    virtual void BuildNativeBinding(std::string_view, std::string_view, bool) {}
    virtual void InvertAxis(u32, bool) {}
    virtual void SaveToSaveState(u8, SaveStateWrapper&) const {}
    virtual void LoadFromSaveState(u8, SaveStateWrapper&) {}
};
class ButtonData { u16 bits; u16 align; };

// ── Pad classes - use weak symbols for ControllerInfo ─────────────────
class PadPopn : public PadBase {
public:
    __attribute__((weak_import)) static const ControllerInfo ControllerInfo;
    PadPopn(u8, u64) : PadBase(0, 0) {}
    virtual ~PadPopn() {}
};

class PadGuitar : public PadBase {
public:
    __attribute__((weak_import)) static const ControllerInfo ControllerInfo;
    PadGuitar(u8, u64) : PadBase(0, 0) {}
    virtual ~PadGuitar() {}
};

class PadJogcon : public PadBase {
public:
    __attribute__((weak_import)) static const ControllerInfo ControllerInfo;
    PadJogcon(u8, u64) : PadBase(0, 0) {}
    virtual ~PadJogcon() {}
};

class PadNegcon : public PadBase {
public:
    __attribute__((weak_import)) static const ControllerInfo ControllerInfo;
    PadNegcon(u8, u64) : PadBase(0, 0) {}
    virtual ~PadNegcon() {}
};