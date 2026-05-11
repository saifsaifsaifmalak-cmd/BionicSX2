#pragma once
#include <string>
#include <cstdint>

// Subsystems
enum class BionicSubsystem : uint8_t {
    CORE   = 0,  // General / VMManager
    EE     = 1,  // Emotion Engine
    IOP    = 2,  // I/O Processor
    VU0    = 3,  // Vector Unit 0
    VU1    = 4,  // Vector Unit 1
    GS     = 5,  // Graphics Synthesizer
    SPU2   = 6,  // Audio
    CDVD   = 7,  // Disc reader
    INPUT  = 8,  // Controller
    MEM    = 9,  // Memory / TLB
    CRASH  = 10, // Signal handler
    WATCH  = 11, // Watchdog
};

// Log levels
enum class BionicLevel : uint8_t {
    INFO  = 0,
    WARN  = 1,
    ERROR = 2,
    FATAL = 3,
};

// Core API
void BionicLog_Init();
void BionicLog_Write(BionicSubsystem sub, BionicLevel level, const char* fmt, ...)
    __attribute__((format(printf, 3, 4)));
void BionicLog_Flush();
void BionicLog_DumpLastLines(int count); // for crash handler
void BionicLog_Heartbeat();             // call from emulation loop
std::string BionicLog_GetPath();

// Macros
#define BIONIC_INFO(sub, fmt, ...)  BionicLog_Write(BionicSubsystem::sub, BionicLevel::INFO,  fmt, ##__VA_ARGS__)
#define BIONIC_WARN(sub, fmt, ...)  BionicLog_Write(BionicSubsystem::sub, BionicLevel::WARN,  fmt, ##__VA_ARGS__)
#define BIONIC_ERROR(sub, fmt, ...) BionicLog_Write(BionicSubsystem::sub, BionicLevel::ERROR, fmt, ##__VA_ARGS__)
#define BIONIC_FATAL(sub, fmt, ...) BionicLog_Write(BionicSubsystem::sub, BionicLevel::FATAL, fmt, ##__VA_ARGS__)