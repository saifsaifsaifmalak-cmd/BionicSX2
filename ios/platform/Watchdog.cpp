#include "BionicLogger.hpp"
#include <pthread.h>
#include <atomic>
#include <unistd.h>
#include <ctime>

static std::atomic<bool>     s_running{false};
static std::atomic<uint64_t> s_lastHeartbeat{0};
static pthread_t             s_thread;
static constexpr int         HANG_TIMEOUT_SEC = 5;

static uint64_t NowSec() {
    return (uint64_t)time(nullptr);
}

void BionicLog_Heartbeat() {
    s_lastHeartbeat.store(NowSec(), std::memory_order_relaxed);
}

static void* WatchdogThread(void*) {
    BIONIC_INFO(WATCH, "Watchdog started (timeout=%ds)", HANG_TIMEOUT_SEC);
    s_lastHeartbeat.store(NowSec(), std::memory_order_relaxed);

    while (s_running.load()) {
        sleep(1);
        uint64_t last = s_lastHeartbeat.load(std::memory_order_relaxed);
        uint64_t now  = NowSec();
        uint64_t diff = now - last;

        if (diff >= HANG_TIMEOUT_SEC) {
            BIONIC_FATAL(WATCH, "══ HANG DETECTED ══");
            BIONIC_FATAL(WATCH, "No heartbeat for %llu seconds!", (unsigned long long)diff);
            BIONIC_FATAL(WATCH, "Emulation loop appears FROZEN or CRASHED");
            BionicLog_DumpLastLines(30);
            BionicLog_Flush();
            // reset لتجنب spam
            s_lastHeartbeat.store(now, std::memory_order_relaxed);
        }
    }
    return nullptr;
}

void Watchdog_Start() {
    s_running.store(true);
    pthread_create(&s_thread, nullptr, WatchdogThread, nullptr);
}

void Watchdog_Stop() {
    s_running.store(false);
    pthread_join(s_thread, nullptr);
    BIONIC_INFO(WATCH, "Watchdog stopped");
}