// EmulatorBridge.h — C++ bridge for Objective-C callers
// Hides all PCSX2 C++ from .mm files
// Phase 4: init/shutdown/state query only

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

bool EmulatorBridge_Init(void);
void EmulatorBridge_Shutdown(void);
bool EmulatorBridge_BootBIOS(const char* biosPath);
void EmulatorBridge_RunFrame(void);
bool EmulatorBridge_IsRunning(void);

#ifdef __cplusplus
}
#endif