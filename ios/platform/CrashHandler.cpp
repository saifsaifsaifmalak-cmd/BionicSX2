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

// Async-signal-safe write helper — only snprintf + write, no allocations
static void RawCrashWrite(const char* msg) {
    if (msg == nullptr) return;
    size_t len = strlen(msg);
    if (len == 0) return;
    write(STDERR_FILENO, msg, len);
}

static void CrashHandler(int sig, siginfo_t* info, void* /*ctx*/) {
    // All output uses only snprintf + write — no BIONIC_FATAL macros,
    // no BionicLogger::log() calls, no mutex, no allocations.
    char buf[512];
    int n;

    n = snprintf(buf, sizeof(buf),
        "══════════════════════════════════\n"
        "SIGNAL RECEIVED: %s (sig=%d)\n",
        SignalName(sig), sig);
    if (n > 0) RawCrashWrite(buf);

    if (info) {
        n = snprintf(buf, sizeof(buf), "Fault address: %p\nSignal code:   %d\n",
                     info->si_addr, info->si_code);
        if (n > 0) RawCrashWrite(buf);
    }

    void* frames[32];
    int count = backtrace(frames, 32);
    char** symbols = backtrace_symbols(frames, count);

    n = snprintf(buf, sizeof(buf), "── Stack Trace (%d frames) ──────\n", count);
    if (n > 0) RawCrashWrite(buf);

    if (symbols) {
        for (int i = 0; i < count; i++) {
            n = snprintf(buf, sizeof(buf), "  [%02d] %s\n", i, symbols[i]);
            if (n > 0) RawCrashWrite(buf);
        }
    } else {
        for (int i = 0; i < count; i++) {
            n = snprintf(buf, sizeof(buf), "  [%02d] %p\n", i, frames[i]);
            if (n > 0) RawCrashWrite(buf);
        }
    }

    // Ring buffer dump — async-signal-safe
    {
        BionicLogger& log = BionicLogger::instance();
        int fd = log.get_log_fd();
        const char* ring = log.get_ring_buffer();
        size_t pos = log.get_write_pos();

        n = snprintf(buf, sizeof(buf),
            "\n══ EMERGENCY DUMP (pos=%zu, size=%zu) ══\n", pos, BionicLogger::BUFFER_SIZE);
        if (n > 0) {
            write(STDERR_FILENO, buf, (size_t)n < sizeof(buf) ? (size_t)n : sizeof(buf));
            if (fd >= 0 && fd != STDERR_FILENO)
                write(fd, buf, (size_t)n < sizeof(buf) ? (size_t)n : sizeof(buf));
        }

        // Dump ring buffer content
        write(STDERR_FILENO, ring, BionicLogger::BUFFER_SIZE);
        if (fd >= 0 && fd != STDERR_FILENO)
            write(fd, ring, BionicLogger::BUFFER_SIZE);

        n = snprintf(buf, sizeof(buf), "\n══ END DUMP ══\n");
        if (n > 0) {
            write(STDERR_FILENO, buf, (size_t)n < sizeof(buf) ? (size_t)n : sizeof(buf));
            if (fd >= 0 && fd != STDERR_FILENO)
                write(fd, buf, (size_t)n < sizeof(buf) ? (size_t)n : sizeof(buf));
        }

        log.flush();
    }

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
