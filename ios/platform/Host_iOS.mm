// Host_iOS.mm — iOS implementation of Host namespace callbacks
// Phase 5: Minimal implementation to satisfy linker + enable BIOS boot
// TODO: Implement fully in Phase 6+

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

#include "common/Pcsx2Defs.h"
#include "Host.h"
#include "VMManager.h"
#include "GS/GS.h"
#include "common/WindowInfo.h"
#include "common/Console.h"
#include "common/SmallString.h"
#include "SettingsInterface.h"

static CAMetalLayer* s_metal_layer = nullptr;
static id<MTLDevice> s_metal_device = nullptr;

extern "C" void BionicSX2_SetMetalLayer(CAMetalLayer* layer, id<MTLDevice> device) {
    s_metal_layer = layer;
    s_metal_device = device;
    NSLog(@"[BionicSX2] Metal layer registered");
}

namespace Host {

// ── Translation (stub) ───────────────────────────────────────────────────
const char* TranslateToCString(const std::string_view context, const std::string_view msg) {
    return msg.data();
}
std::string_view TranslateToStringView(const std::string_view context, const std::string_view msg) {
    return msg;
}
std::string TranslateToString(const std::string_view context, const std::string_view msg) {
    return std::string(msg);
}
std::string TranslatePluralToString(const char* context, const char* msg, const char* disambiguation, int count) {
    return std::string(msg);
}
void ClearTranslationCache() {}

// ── OSD Messages ────────────────────────────────────────────────────────
void AddOSDMessage(std::string message, float duration) {
    NSLog(@"[BionicSX2] OSD: %s", message.c_str());
}
void AddKeyedOSDMessage(std::string key, std::string message, float duration) {
    NSLog(@"[BionicSX2] OSD[%s]: %s", key.c_str(), message.c_str());
}
void AddIconOSDMessage(std::string key, const char* icon, const std::string_view message, float duration) {
    NSLog(@"[BionicSX2] OSD[%s] %s: %s", key.c_str(), icon, std::string(message).c_str());
}
void RemoveKeyedOSDMessage(std::string key) {}
void ClearOSDMessages() {}

// ── Async Reports ────────────────────────────────────────────────────
void ReportInfoAsync(const std::string_view title, const std::string_view message) {
    NSLog(@"[BionicSX2] INFO: %s — %s", std::string(title).c_str(), std::string(message).c_str());
}
void ReportFormattedInfoAsync(const std::string_view title, const char* format, ...) {}
void ReportErrorAsync(const std::string_view title, const std::string_view message) {
    NSLog(@"[BionicSX2] ERROR: %s — %s", std::string(title).c_str(), std::string(message).c_str());
}
void ReportFormattedErrorAsync(const std::string_view title, const char* format, ...) {}

// ── Batch Mode ────────────────────────────────────────────────────────
bool InBatchMode() { return false; }
bool InNoGUIMode() { return false; }

// ── URL / Clipboard ─────────────────────────────────────────────────
void OpenURL(const std::string_view url) {
    NSLog(@"[BionicSX2] OpenURL: %s", std::string(url).c_str());
}
bool CopyTextToClipboard(const std::string_view text) { return false; }

// ── Settings Reset ───���────────────────────────────────────────────────────
bool RequestResetSettings(bool folders, bool core, bool controllers, bool hotkeys, bool ui) {
    return false;
}

// ── Display Resize ────────────────────────────────────────────────────────
void RequestResizeHostDisplay(s32 width, s32 height) {}

// ── Thread Execution ────────────────────────────────────────────────────
void RunOnCPUThread(std::function<void()> function, bool block) {
    function();
}
void RunOnGSThread(std::function<void()> function) {
    function();
}

// ── Game List ──────────────────────────────────────────────────────────
void RefreshGameListAsync(bool invalidate_cache) {}
void CancelGameListRefresh() {}

// ── VM Shutdown Request ──────────────────────────────────────────────
void RequestVMShutdown(bool allow_confirm, bool allow_save_state, bool default_save_state) {}

// ── HTTP User Agent ────────────────────────────────────────────────
std::string GetHTTPUserAgent() {
    return "BionicSX2/1.0 (iOS)";
}

// ── Base Settings ────────────────────────────────────────────────────
std::string GetBaseStringSettingValue(const char* section, const char* key, const char* default_value) {
    return default_value ? default_value : "";
}
SmallString GetBaseSmallStringSettingValue(const char* section, const char* key, const char* default_value) {
    return default_value ? default_value : "";
}
TinyString GetBaseTinyStringSettingValue(const char* section, const char* key, const char* default_value) {
    return default_value ? default_value : "";
}
bool GetBaseBoolSettingValue(const char* section, const char* key, bool default_value) { return default_value; }
int GetBaseIntSettingValue(const char* section, const char* key, int default_value) { return default_value; }
uint GetBaseUIntSettingValue(const char* section, const char* key, uint default_value) { return default_value; }
float GetBaseFloatSettingValue(const char* section, const char* key, float default_value) { return default_value; }
double GetBaseDoubleSettingValue(const char* section, const char* key, double default_value) { return default_value; }
std::vector<std::string> GetBaseStringListSetting(const char* section, const char* key) { return {}; }

// ── Base Settings Write ────────────────────────────────────────────
void SetBaseBoolSettingValue(const char* section, const char* key, bool value) {}
void SetBaseIntSettingValue(const char* section, const char* key, int value) {}
void SetBaseUIntSettingValue(const char* section, const char* key, uint value) {}
void SetBaseFloatSettingValue(const char* section, const char* key, float value) {}
void SetBaseStringSettingValue(const char* section, const char* key, const char* value) {}
void SetBaseStringListSettingValue(const char* section, const char* key, const std::vector<std::string>& values) {}
bool AddBaseValueToStringList(const char* section, const char* key, const char* value) { return false; }
bool RemoveBaseValueFromStringList(const char* section, const char* key, const char* value) { return false; }
bool ContainsBaseSettingValue(const char* section, const char* key) { return false; }
void RemoveBaseSettingValue(const char* section, const char* key) {}
void CommitBaseSettingChanges() {}

// ── Settings (with layer) ────────────────────────────────────────────
std::string GetStringSettingValue(const char* section, const char* key, const char* default_value) {
    return GetBaseStringSettingValue(section, key, default_value);
}
SmallString GetSmallStringSettingValue(const char* section, const char* key, const char* default_value) {
    return GetBaseSmallStringSettingValue(section, key, default_value);
}
TinyString GetTinyStringSettingValue(const char* section, const char* key, const char* default_value) {
    return GetBaseTinyStringSettingValue(section, key, default_value);
}
bool GetBoolSettingValue(const char* section, const char* key, bool default_value) {
    return GetBaseBoolSettingValue(section, key, default_value);
}
int GetIntSettingValue(const char* section, const char* key, int default_value) {
    return GetBaseIntSettingValue(section, key, default_value);
}
uint GetUIntSettingValue(const char* section, const char* key, uint default_value) {
    return GetBaseUIntSettingValue(section, key, default_value);
}
float GetFloatSettingValue(const char* section, const char* key, float default_value) {
    return GetBaseFloatSettingValue(section, key, default_value);
}
double GetDoubleSettingValue(const char* section, const char* key, double default_value) {
    return GetBaseDoubleSettingValue(section, key, default_value);
}
std::vector<std::string> GetStringListSetting(const char* section, const char* key) {
    return GetBaseStringListSetting(section, key);
}

// ── Settings Lock ────────────────────────────────────────────────
std::unique_lock<std::mutex> GetSettingsLock() {
    static std::mutex m;
    return std::unique_lock<std::mutex>(m);
}
std::unique_lock<std::mutex> GetSecretsSettingsLock() {
    static std::mutex m;
    return std::unique_lock<std::mutex>(m);
}
SettingsInterface* GetSettingsInterface() { return nullptr; }

// ── Default Settings ────────────────────────────────────────────────
void SetDefaultUISettings(SettingsInterface& si) {}

// ── Progress Callback ──────────────────────────────────────────
std::unique_ptr<ProgressCallback> CreateHostProgressCallback() {
    return nullptr;
}

// ── Locale ──────────────────────────────────────────────────────
int LocaleSensitiveCompare(std::string_view lhs, std::string_view rhs) {
    return lhs.compare(rhs);
}

namespace Internal {

SettingsInterface* GetBaseSettingsLayer() { return nullptr; }
SettingsInterface* GetSecretsSettingsLayer() { return nullptr; }
SettingsInterface* GetGameSettingsLayer() { return nullptr; }
SettingsInterface* GetInputSettingsLayer() { return nullptr; }

void SetBaseSettingsLayer(SettingsInterface* sif) {}
void SetSecretsSettingsLayer(SettingsInterface* sif) {}
void SetGameSettingsLayer(SettingsInterface* sif, std::unique_lock<std::mutex>& settings_lock) {}
void SetInputSettingsLayer(SettingsInterface* sif, std::unique_lock<std::mutex>& settings_lock) {}

s32 GetTranslatedStringImpl(const std::string_view context, const std::string_view msg, char* tbuf, size_t tbuf_space) {
    if (msg.size() >= tbuf_space) return -1;
    std::memcpy(tbuf, msg.data(), msg.size());
    tbuf[msg.size()] = '\0';
    return msg.size();
}

} // namespace Internal

} // namespace Host

// VMManager Host callbacks (these are separate namespace)
namespace VMManager {

void OnVMStarting() {
    NSLog(@"[BionicSX2] VM Starting");
}
void OnVMStarted() {
    NSLog(@"[BionicSX2] VM Started");
}
void OnVMDestroyed() {
    NSLog(@"[BionicSX2] VM Destroyed");
}
void OnVMPaused() {
    NSLog(@"[BionicSX2] VM Paused");
}
void OnVMResumed() {
    NSLog(@"[BionicSX2] VM Resumed");
}
void OnPerformanceMetricsUpdated() {}
void OnSaveStateLoading(const std::string_view filename) {}
void OnSaveStateLoaded(const std::string_view filename, bool was_successful) {}
void OnSaveStateSaved(const std::string_view filename) {}
void OnGameChanged(const std::string& title, const std::string& elf_override, const std::string& disc_path,
                 const std::string& disc_serial, u32 disc_crc, const std::string& save_state_to_load) {
    NSLog(@"[BionicSX2] Game: %s", title.c_str());
}
void CheckForSettingsChanges(const Pcsx2Config& old_config) {}

} // namespace VMManager