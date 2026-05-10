// PCSX2Stubs.mm — minimal iOS stubs
#import <Foundation/Foundation.h>
#include <string>
#include <optional>

typedef unsigned int u32;
typedef unsigned long long u64;
typedef unsigned char u8;
typedef unsigned short u16;
typedef int s32;

extern "C" {

void DEV9shutdown() {}
void DEV9close() {}
void USBclose() {}
void gsIrq() {}

void AbortWithMessage(const char* msg) {
    NSLog(@"[BionicSX2] ABORT: %s", msg ? msg : "unknown");
    abort();
}

// MakeGSDeviceMTL
class GSDevice;
GSDevice* MakeGSDeviceMTL() { return nullptr; }

// Threading - keep as minimal shell
namespace Threading {
    class KernelSemaphore { public: void Post() {} void Wait() {} };
    class Thread { public: void Join() {} };
    class ThreadHandle { public: void SetAffinity(unsigned long long) {} };
}

// SharedMemory
class SharedMemoryMappingArea {
public:
    void Unmap(void* a, unsigned long b, bool c) {}
};

namespace InputRecording {
    bool isActive() { return false; }
    void stop() {}
}
bool g_InputRecording = false;

// Hotkey globals - define as empty
struct HotkeyInfo {
    const char* name;
    const char* category;
    const char* display_name;
    void (*handler)(s32 pressed);
};

} // extern "C"