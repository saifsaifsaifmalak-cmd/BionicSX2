#include "BionicLogger.hpp"
#import <Foundation/Foundation.h>
#include <mutex>
#include <deque>
#include <cstdio>
#include <cstdarg>
#include <ctime>

static std::mutex       s_mutex;
static FILE*            s_file    = nullptr;
static std::deque<std::string> s_ringbuf; // آخر 100 سطر في الذاكرة
static constexpr int    RING_SIZE = 100;

static const char* SubsystemName(BionicSubsystem s) {
    switch(s) {
        case BionicSubsystem::CORE:  return "CORE ";
        case BionicSubsystem::EE:    return "EE   ";
        case BionicSubsystem::IOP:   return "IOP  ";
        case BionicSubsystem::VU0:   return "VU0  ";
        case BionicSubsystem::VU1:   return "VU1  ";
        case BionicSubsystem::GS:    return "GS   ";
        case BionicSubsystem::SPU2:  return "SPU2 ";
        case BionicSubsystem::CDVD:  return "CDVD ";
        case BionicSubsystem::INPUT: return "INPUT";
        case BionicSubsystem::MEM:   return "MEM  ";
        case BionicSubsystem::CRASH: return "CRASH";
        case BionicSubsystem::WATCH: return "WATCH";
        default:                     return "?????";
    }
}

static const char* LevelName(BionicLevel l) {
    switch(l) {
        case BionicLevel::INFO:  return "INFO ";
        case BionicLevel::WARN:  return "WARN ";
        case BionicLevel::ERROR: return "ERROR";
        case BionicLevel::FATAL: return "FATAL";
        default:                 return "?????";
    }
}

std::string BionicLog_GetPath() {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    time_t now = time(nullptr);
    struct tm* t = localtime(&now);
    char buf[64];
    strftime(buf, sizeof(buf), "bionics2_%Y-%m-%d_%H-%M.log", t);

    return std::string([docs UTF8String]) + "/" + buf;
}

void BionicLog_Init() {
    std::lock_guard<std::mutex> lock(s_mutex);
    if (s_file) return;

    std::string path = BionicLog_GetPath();
    s_file = fopen(path.c_str(), "w");
    if (!s_file) return;

    fprintf(s_file, "══════════════════════════════════════\n");
    fprintf(s_file, "  BionicSX2 Diagnostic Log\n");
    fprintf(s_file, "  Path: %s\n", path.c_str());
    fprintf(s_file, "══════════════════════════════════════\n\n");
    fflush(s_file);
}

void BionicLog_Write(BionicSubsystem sub, BionicLevel level, const char* fmt, ...) {
    char msg[1024];
    va_list args;
    va_start(args, fmt);
    vsnprintf(msg, sizeof(msg), fmt, args);
    va_end(args);

    time_t now = time(nullptr);
    struct tm* t = localtime(&now);
    char timebuf[32];
    strftime(timebuf, sizeof(timebuf), "%H:%M:%S", t);

    char line[1200];
    snprintf(line, sizeof(line), "[%s] [%s] [%s] %s\n",
             timebuf, LevelName(level), SubsystemName(sub), msg);

    std::lock_guard<std::mutex> lock(s_mutex);

    // Ring buffer في الذاكرة
    s_ringbuf.push_back(line);
    if ((int)s_ringbuf.size() > RING_SIZE)
        s_ringbuf.pop_front();

    // كتابة للملف
    if (s_file) {
        fputs(line, s_file);
        // flush فوري للأخطاء الحرجة
        if (level >= BionicLevel::ERROR)
            fflush(s_file);
    }
}

void BionicLog_Flush() {
    std::lock_guard<std::mutex> lock(s_mutex);
    if (s_file) fflush(s_file);
}

void BionicLog_DumpLastLines(int count) {
    // يُستدعى من signal handler — بدون mutex لتجنب deadlock
    if (!s_file) return;
    fprintf(s_file, "\n══ EMERGENCY DUMP (last %d lines) ══\n", count);
    int start = (int)s_ringbuf.size() - count;
    if (start < 0) start = 0;
    for (int i = start; i < (int)s_ringbuf.size(); i++)
        fputs(s_ringbuf[i].c_str(), s_file);
    fprintf(s_file, "══ END DUMP ══\n");
    fflush(s_file);
}