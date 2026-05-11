#include "BionicLogger.hpp"
#include <signal.h>
#include <execinfo.h>
#include <unistd.h>
#include <cstdio>
#include <cstring>

static const char* SignalName(int sig) {
    switch(sig) {
        case SIGSEGV: return "SIGSEGV (Segmentation Fault)";
        case SIGABRT: return "SIGABRT (Abort)";
        case SIGBUS:  return "SIGBUS  (Bus Error)";
        case SIGILL:  return "SIGILL  (Illegal Instruction)";
        case SIGFPE:  return "SIGFPE  (Floating Point Exception)";
        default:      return "UNKNOWN SIGNAL";
    }
}

static void CrashHandler(int sig, siginfo_t* info, void* /*ctx*/) {
    BIONIC_FATAL(CRASH, "══════════════════════════════════");
    BIONIC_FATAL(CRASH, "SIGNAL RECEIVED: %s (sig=%d)", SignalName(sig), sig);
    if (info) {
        BIONIC_FATAL(CRASH, "Fault address: %p", info->si_addr);
        BIONIC_FATAL(CRASH, "Signal code:   %d", info->si_code);
    }

    // Stack trace
    void* frames[32];
    int count = backtrace(frames, 32);
    char** symbols = backtrace_symbols(frames, count);

    BIONIC_FATAL(CRASH, "── Stack Trace (%d frames) ──────", count);
    if (symbols) {
        for (int i = 0; i < count; i++)
            BIONIC_FATAL(CRASH, "  [%02d] %s", i, symbols[i]);
    } else {
        for (int i = 0; i < count; i++)
            BIONIC_FATAL(CRASH, "  [%02d] %p", i, frames[i]);
    }

    BionicLog_DumpLastLines(50);
    BionicLog_Flush();

    // إعادة الإشارة الأصلية
    signal(sig, SIG_DFL);
    raise(sig);
}

void CrashHandler_Install() {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_sigaction = CrashHandler;
    sa.sa_flags = SA_SIGINFO;
    sigemptyset(&sa.sa_mask);

    sigaction(SIGSEGV, &sa, nullptr);
    sigaction(SIGABRT, &sa, nullptr);
    sigaction(SIGBUS,  &sa, nullptr);
    sigaction(SIGILL,  &sa, nullptr);
    sigaction(SIGFPE,  &sa, nullptr);

    BIONIC_INFO(CRASH, "Crash handler installed (SIGSEGV/SIGABRT/SIGBUS/SIGILL/SIGFPE)");
}