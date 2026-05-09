// BionicSX2 — Host Implementation for iOS
// Implements all Host:: callbacks required by PCSX2 core
// Phase 4: minimal stubs sufficient for BIOS boot
// Phase 5: connect to MetalViewController, GSDeviceMTL

#include "Host.h"
#include "GS.h"
#include "VMManager.h"
#include "Input/InputManager.h"
#include "common/ProgressCallback.h"
#include "common/SettingsInterface.h"
#include <cstring>
#include <mutex>

namespace Host {

std::optional<WindowInfo> AcquireRenderWindow(bool recreate_window) {
    return std::nullopt;
}

void ReleaseRenderWindow() {
}

void BeginPresentFrame() {
}

bool IsFullscreen() {
    return false;
}

void SetFullscreen(bool enabled) {
}

void OnCaptureStarted(const std::string& filename) {
}

void OnCaptureStopped() {
}

void RequestResizeHostDisplay(s32 width, s32 height) {
}

void LoadSettings(SettingsInterface& si, std::unique_lock<std::mutex>& lock) {
}

void CheckForSettingsChanges(const Pcsx2Config& old_config) {
}

void SetDefaultUISettings(SettingsInterface& si) {
}

std::unique_ptr<ProgressCallback> CreateHostProgressCallback() {
    return ProgressCallback::CreateNullProgressCallback();
}

void ReportInfoAsync(const std::string_view title, const std::string_view message) {
}

void ReportErrorAsync(const std::string_view title, const std::string_view message) {
}

void OpenURL(const std::string_view url) {
}

bool InBatchMode() {
    return false;
}

bool InNoGUIMode() {
    return false;
}

bool CopyTextToClipboard(const std::string_view text) {
    return false;
}

void BeginTextInput() {
}

void EndTextInput() {
}

std::optional<WindowInfo> GetTopLevelWindowInfo() {
    return std::nullopt;
}

void SetMouseMode(bool relative_mode, bool hide_cursor) {
}

void SetMouseLock(bool state) {
}

bool RequestResetSettings(bool folders, bool core, bool controllers, bool hotkeys, bool ui) {
    return false;
}

void RunOnCPUThread(std::function<void()> function, bool block) {
    if (block) {
        function();
    } else {
        function();
    }
}

void RunOnGSThread(std::function<void()> function) {
    function();
}

void RefreshGameListAsync(bool invalidate_cache) {
}

void CancelGameListRefresh() {
}

void RequestVMShutdown(bool allow_confirm, bool allow_save_state, bool default_save_state) {
}

void RequestExitApplication(bool allow_confirm) {
}

void RequestExitBigPicture() {
}

std::string GetHTTPUserAgent() {
    return "BionicSX2/0.1.0";
}

std::string GetBaseStringSettingValue(const char* section, const char* key, const char* default_value) {
    return default_value ? std::string(default_value) : std::string();
}

SmallString GetBaseSmallStringSettingValue(const char* section, const char* key, const char* default_value) {
    return SmallString(default_value);
}

TinyString GetBaseTinyStringSettingValue(const char* section, const char* key, const char* default_value) {
    return TinyString(default_value);
}

bool GetBaseBoolSettingValue(const char* section, const char* key, bool default_value) {
    return default_value;
}

int GetBaseIntSettingValue(const char* section, const char* key, int default_value) {
    return default_value;
}

uint GetBaseUIntSettingValue(const char* section, const char* key, uint default_value) {
    return default_value;
}

float GetBaseFloatSettingValue(const char* section, const char* key, float default_value) {
    return default_value;
}

double GetBaseDoubleSettingValue(const char* section, const char* key, double default_value) {
    return default_value;
}

std::vector<std::string> GetBaseStringListSetting(const char* section, const char* key) {
    return {};
}

void SetBaseBoolSettingValue(const char* section, const char* key, bool value) {
}

void SetBaseIntSettingValue(const char* section, const char* key, int value) {
}

void SetBaseUIntSettingValue(const char* section, const char* key, uint value) {
}

void SetBaseFloatSettingValue(const char* section, const char* key, float value) {
}

void SetBaseStringSettingValue(const char* section, const char* key, const char* value) {
}

void SetBaseStringListSettingValue(const char* section, const char* key, const std::vector<std::string>& values) {
}

bool AddBaseValueToStringList(const char* section, const char* key, const char* value) {
    return false;
}

bool RemoveBaseValueFromStringList(const char* section, const char* key, const char* value) {
    return false;
}

bool ContainsBaseSettingValue(const char* section, const char* key) {
    return false;
}

void RemoveBaseSettingValue(const char* section, const char* key) {
}

void CommitBaseSettingChanges() {
}

std::string GetStringSettingValue(const char* section, const char* key, const char* default_value) {
    return default_value ? std::string(default_value) : std::string();
}

SmallString GetSmallStringSettingValue(const char* section, const char* key, const char* default_value) {
    return SmallString(default_value);
}

TinyString GetTinyStringSettingValue(const char* section, const char* key, const char* default_value) {
    return TinyString(default_value);
}

bool GetBoolSettingValue(const char* section, const char* key, bool default_value) {
    return default_value;
}

int GetIntSettingValue(const char* section, const char* key, int default_value) {
    return default_value;
}

uint GetUIntSettingValue(const char* section, const char* key, uint default_value) {
    return default_value;
}

float GetFloatSettingValue(const char* section, const char* key, float default_value) {
    return default_value;
}

double GetDoubleSettingValue(const char* section, const char* key, double default_value) {
    return default_value;
}

std::vector<std::string> GetStringListSetting(const char* section, const char* key) {
    return {};
}

std::unique_lock<std::mutex> GetSettingsLock() {
    static std::mutex s_mutex;
    return std::unique_lock<std::mutex>(s_mutex);
}

std::unique_lock<std::mutex> GetSecretsSettingsLock() {
    static std::mutex s_mutex;
    return std::unique_lock<std::mutex>(s_mutex);
}

SettingsInterface* GetSettingsInterface() {
    return nullptr;
}

int LocaleSensitiveCompare(std::string_view lhs, std::string_view rhs) {
    int res = std::strncmp(lhs.data(), rhs.data(), std::min(lhs.size(), rhs.size()));
    if (res != 0)
        return res;
    return lhs.size() > rhs.size() ? 1 : lhs.size() < rhs.size() ? -1 : 0;
}

const char* TranslateToCString(const std::string_view context, const std::string_view msg) {
    static thread_local char buf[4096];
    size_t len = std::min(msg.size(), sizeof(buf) - 1);
    std::memcpy(buf, msg.data(), len);
    buf[len] = '\0';
    return buf;
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

void ClearTranslationCache() {
}

void AddOSDMessage(std::string message, float duration) {
}

void AddKeyedOSDMessage(std::string key, std::string message, float duration) {
}

void AddIconOSDMessage(std::string key, const char* icon, const std::string_view message, float duration) {
}

void RemoveKeyedOSDMessage(std::string key) {
}

void ClearOSDMessages() {
}

void OnVMStarting() {
}

void OnVMStarted() {
}

void OnVMDestroyed() {
}

void OnVMPaused() {
}

void OnVMResumed() {
}

void OnPerformanceMetricsUpdated() {
}

void OnSaveStateLoading(const std::string_view filename) {
}

void OnSaveStateLoaded(const std::string_view filename, bool was_successful) {
}

void OnSaveStateSaved(const std::string_view filename) {
}

void OnGameChanged(const std::string& title, const std::string& elf_override, const std::string& disc_path,
    const std::string& disc_serial, u32 disc_crc, u32 current_crc) {
}

void OnInputDeviceConnected(const std::string_view identifier, const std::string_view device_name) {
}

void OnInputDeviceDisconnected(const InputBindingKey key, const std::string_view identifier) {
}

void PumpMessagesOnCPUThread() {
}

namespace Internal {

SettingsInterface* GetBaseSettingsLayer() {
    return nullptr;
}

SettingsInterface* GetSecretsSettingsLayer() {
    return nullptr;
}

SettingsInterface* GetGameSettingsLayer() {
    return nullptr;
}

SettingsInterface* GetInputSettingsLayer() {
    return nullptr;
}

void SetBaseSettingsLayer(SettingsInterface* sif) {
}

void SetSecretsSettingsLayer(SettingsInterface* sif) {
}

void SetGameSettingsLayer(SettingsInterface* sif, std::unique_lock<std::mutex>& settings_lock) {
}

void SetInputSettingsLayer(SettingsInterface* sif, std::unique_lock<std::mutex>& settings_lock) {
}

s32 GetTranslatedStringImpl(const std::string_view context, const std::string_view msg, char* tbuf, size_t tbuf_space) {
    if (msg.size() > tbuf_space)
        return -1;
    else if (msg.empty())
        return 0;
    std::memcpy(tbuf, msg.data(), msg.size());
    return static_cast<s32>(msg.size());
}

} // namespace Internal

} // namespace Host

BEGIN_HOTKEY_LIST(g_common_hotkeys)
END_HOTKEY_LIST()

BEGIN_HOTKEY_LIST(g_gs_hotkeys)
END_HOTKEY_LIST()

BEGIN_HOTKEY_LIST(g_host_hotkeys)
END_HOTKEY_LIST()

std::optional<u32> InputManager::ConvertHostKeyboardStringToCode(const std::string_view str) {
    return std::nullopt;
}

std::optional<std::string> InputManager::ConvertHostKeyboardCodeToString(u32 code) {
    return std::nullopt;
}

const char* InputManager::ConvertHostKeyboardCodeToIcon(u32 code) {
    return nullptr;
}