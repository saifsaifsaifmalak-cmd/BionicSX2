#pragma once
#include <setjmp.h>
void CrashHandler_Install();
void CrashHandler_SetJumpBuf(jmp_buf* jmp);