// PCSX2Stubs.mm — iOS stubs for minimal linking
#import <Foundation/Foundation.h>
#include <string>

extern "C" {

// ── DEV9 stubs ────────────────────────────────────────────────────────────
void DEV9shutdown() {}
void DEV9close() {}
void DEV9irqHandler() {}

// ── USB stubs ────────────────────────────────────────────────────────────
void USBclose() {}

// ── gsIrq ─────────────────────────────────────────────────────────────────
void gsIrq() {}

// ── AbortWithMessage ─────────────────────────────────────────────────────
void AbortWithMessage(const char* msg) {
    NSLog(@"[BionicSX2] ABORT: %s", msg ? msg : "unknown");
    abort();
}

// ── MakeGSDeviceMTL ─────────────────────────────────────────────────────
class GSDevice;
GSDevice* MakeGSDeviceMTL() { return nullptr; }

// ── Threading stubs ───────────────────────────────────────────────────────
namespace Threading {
    class KernelSemaphore {
    public: KernelSemaphore() {} ~KernelSemaphore() {} void Post() {} void Wait() {}
    };
    class Thread {
    public: Thread() {} ~Thread() {} void Join() {}
    };
    class ThreadHandle {
    public: ThreadHandle() {} ~ThreadHandle() {} void SetAffinity(unsigned long long) {}
    };
}

// ── SharedMemoryMappingArea stub ─────────────────────────────────────────
class SharedMemoryMappingArea {
public:
    SharedMemoryMappingArea() {}
    ~SharedMemoryMappingArea() {}
    void Unmap(void* addr, u64 size, bool) { (void)addr; (void)size; }
};

// ── InputRecording stubs ───────────────────────────────────────────────
namespace InputRecording {
    bool isActive() { return false; }
    void stop() {}
}
bool g_InputRecording = false;

// ── Hotkey globals ─────────────────────────────────────────────────────
struct HotkeyInfo {
    const char* name;
    const char* category;
    const char* display_name;
    void (*handler)(s32 pressed);
};
extern const HotkeyInfo g_common_hotkeys[];
extern const HotkeyInfo g_host_hotkeys[];

} // extern "C"

// ── Host stubs (matching Host_iOS.mm declarations) ─────────────────────
namespace Host {
    void OnGameChanged(const std::string&, const std::string&, const std::string&, const std::string&, u32, u32) {}
    void OnVMDestroyed() {}
    void OnSaveStateSaved(std::string_view) {}
    void ReleaseRenderWindow() {}
    void SetMouseMode(bool, bool) {}
}

// ── FullscreenUI stubs ─────────────────────────────────────────────────
namespace FullscreenUI {
    void GameChanged(const std::string&, const std::string&, const std::string&, u32, u32) {}
    void OnVMDestroyed() {}
}

// ── ImGuiManager stubs ─────────────────────────────────────────────────
class ImGuiManager {
public:
    void Initialize() {}
    void Shutdown(bool) {}
    void ReloadFonts() {}
    void RequestScaleUpdate() {}
    bool HasSoftwareCursor(u32) { return false; }
};
ImGuiManager* g_imGuiManager = nullptr;

// ── GS stubs ─────────────────────────────────────────────────────────────
namespace GSCapture {
    void BeginCapture(float, class GSVector2i, float, const std::string&) {}
    std::string GetNextCaptureFileName() { return ""; }
    class GSVector2i GetSize() { return {}; }
}
class GSDrawingContext {
public:
    void Dump(const std::string&) const {}
    void UpdateScissor() {}
};
class GSDrawingEnvironment {
public:
    void Dump(const std::string&) const {}
};
namespace GSPng {
    bool Save(int, const std::string&, const u8*, int, int, int, int, bool) { return false; }
}
class GSRendererHW {
public: GSRendererHW() {}
};
class GSRendererNull {
public: GSRendererNull() {}
};
namespace GSTextureReplacements {
    void ReloadReplacementMap() {}
    void Shutdown() {}
    void UpdateConfig(class Pcsx2Config::GSOptions&) {}
}

// ── GS Vector stubs ───────────────────────────────────────────────────
namespace GS {
    class Vector4i {
    public: static const int m_x0f = 0; 
    };
    void Update(const void*, const u16*, int, int, int) {}
}
namespace isa_native {
    void* makeGSRendererSW(int) { return nullptr; }
}

// ── USB extended stubs ─────────────────────────────────────────────────
namespace USB {
    const char* GetConfigDevice(const class SettingsInterface&, unsigned int) { return nullptr; }
    const char* GetConfigSubKey(std::string_view, std::string_view) { return nullptr; }
    const char* GetConfigSubType(const class SettingsInterface&, unsigned int, std::string_view) { return nullptr; }
    void GetDeviceBindings(std::string_view, unsigned int) {}
    void SetDeviceBindValue(unsigned int, unsigned int, float) {}
}

// ── IOCtlSrc stub ──────────────────────────────────────────────────────
class IOCtlSrc {
public: ~IOCtlSrc() {}
};

// ── InputManager keyboard stubs ───────────────────────────────────────
namespace InputManager {
    std::string ConvertHostKeyboardCodeToString(u32) { return ""; }
    std::optional<u32> ConvertHostKeyboardStringToCode(std::string_view) { return 0; }
}