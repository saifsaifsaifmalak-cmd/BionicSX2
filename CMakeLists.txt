cmake_minimum_required(VERSION 3.20)

project(BionicSX2
    VERSION 0.1.0
    LANGUAGES C CXX OBJC OBJCXX
)

# ─── iOS Target Guard ──────────────────────────────────────────────────────
if(NOT PCSX2_TARGET_IOS)
    message(FATAL_ERROR
        "BionicSX2 is an iOS-only project.\n"
        "Configure with: -DPCSX2_TARGET_IOS=ON\n"
        "and: -DCMAKE_TOOLCHAIN_FILE=cmake/ios.toolchain.cmake"
    )
endif()

# ─── C++ Standard ──────────────────────────────────────────────────────────
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ─── ARM64 Verification ────────────────────────────────────────────────────
if(NOT CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
    message(FATAL_ERROR
        "BionicSX2 requires ARM64. Got: ${CMAKE_SYSTEM_PROCESSOR}"
    )
endif()

# ─── Global Compile Definitions ────────────────────────────────────────────
add_compile_definitions(
    PCSX2_TARGET_IOS=1
    _M_ARM64=1
    TARGET_OS_IPHONE=1
    DISABLE_PCSX2_RECOMPILER=1
    DISABLE_VULKAN=1
    DISABLE_ANDROID=1
)

# ─── 3rdparty dependencies ───────────────────────────────────────────────

# fmt — header-only + compiled
add_subdirectory(pcsx2/3rdparty/fmt EXCLUDE_FROM_ALL)

# fast_float — header-only
add_subdirectory(pcsx2/3rdparty/fast_float EXCLUDE_FROM_ALL)

# rapidyaml / ryml — disable c4core fast_float (uses Windows x86 intrinsics incompatible with iOS/clang)
# c4core's nested fast_float uses _M_ARM64 to detect ARM64 but then includes <intrin.h> which is Windows-only.
# This is a known incompatibility in c4core's fast_float when cross-compiling.
set(C4CORE_WITH_FASTFLOAT OFF CACHE BOOL "" FORCE)
add_subdirectory(pcsx2/3rdparty/ryml EXCLUDE_FROM_ALL)

# zlib — NOT FOUND in pcsx2/3rdparty
# add_subdirectory(pcsx2/3rdparty/zlib EXCLUDE_FROM_ALL)  # Directory does not exist

# ── Image Libraries (built from source for iOS ARM64) ──────────────────

# libjpeg-turbo — native ARM64 SIMD, supports CMake cross-compile
set(ENABLE_SHARED     OFF CACHE BOOL "" FORCE)
set(ENABLE_STATIC     ON  CACHE BOOL "" FORCE)
set(WITH_TURBOJPEG    OFF CACHE BOOL "" FORCE)
set(WITH_JAVA         OFF CACHE BOOL "" FORCE)
set(WITH_SIMD         ON  CACHE BOOL "" FORCE)
set(CMAKE_INSTALL_DOCDIR "share/doc/libjpeg-turbo" CACHE STRING "" FORCE)
set(CMAKE_INSTALL_MANDIR "share/man" CACHE STRING "" FORCE)
set(CMAKE_INSTALL_DOXYDIR "share/doc" CACHE STRING "" FORCE)
add_subdirectory(3rdparty/libjpeg-turbo EXCLUDE_FROM_ALL)
target_include_directories(jpeg-static PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libjpeg-turbo/src>
    $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/3rdparty/libjpeg-turbo>
)
add_library(JPEG::JPEG ALIAS jpeg-static)

# libpng — zlib is part of iOS SDK
find_package(ZLIB QUIET)
set(PNG_SHARED    OFF CACHE BOOL "" FORCE)
set(PNG_STATIC    ON  CACHE BOOL "" FORCE)
set(PNG_TESTS     OFF CACHE BOOL "" FORCE)
add_subdirectory(3rdparty/libpng EXCLUDE_FROM_ALL)
add_library(PNG::PNG ALIAS png_static)

# libwebp
set(WEBP_BUILD_ANIM_UTILS OFF CACHE BOOL "" FORCE)
set(WEBP_BUILD_CWEBP      OFF CACHE BOOL "" FORCE)
set(WEBP_BUILD_DWEBP      OFF CACHE BOOL "" FORCE)
set(WEBP_BUILD_GIF2WEBP   OFF CACHE BOOL "" FORCE)
set(WEBP_BUILD_IMG2WEBP   OFF CACHE BOOL "" FORCE)
set(WEBP_BUILD_VWEBP      OFF CACHE BOOL "" FORCE)
set(WEBP_BUILD_WEBPINFO   OFF CACHE BOOL "" FORCE)
set(WEBP_BUILD_WEBPMUX    OFF CACHE BOOL "" FORCE)
set(WEBP_BUILD_EXTRAS     OFF CACHE BOOL "" FORCE)
set(WEBP_BUILD_WEBP_JS     OFF CACHE BOOL "" FORCE)
add_subdirectory(3rdparty/libwebp EXCLUDE_FROM_ALL)
if(NOT TARGET WebP::libwebp)
    add_library(WebP::libwebp ALIAS webp)
endif()

# cpuinfo — ARM64 CPU feature detection
set(CPUINFO_BUILD_TOOLS OFF CACHE BOOL "" FORCE)
set(CPUINFO_BUILD_UNIT_TESTS OFF CACHE BOOL "" FORCE)
set(CPUINFO_BUILD_MOCK_TESTS OFF CACHE BOOL "" FORCE)
set(CPUINFO_BUILD_BENCHMARKS OFF CACHE BOOL "" FORCE)
add_subdirectory(pcsx2/3rdparty/cpuinfo EXCLUDE_FROM_ALL)

# ─── pcsx2_common — platform-agnostic utilities ───────────────────────────

set(PCSX2_COMMON_SOURCES
    # [SAFE] — verified in Layer 0 audit
    pcsx2/common/AlignedMalloc.cpp
    pcsx2/common/Assertions.cpp
    pcsx2/common/Console.cpp
    pcsx2/common/CrashHandler.cpp
    pcsx2/common/DynamicLibrary.cpp
    pcsx2/common/Error.cpp
    pcsx2/common/FastJmp.cpp
    pcsx2/common/FileSystem.cpp
    pcsx2/common/HTTPDownloader.cpp
    pcsx2/common/Image.cpp
    pcsx2/common/MD5Digest.cpp
    pcsx2/common/MemoryInterface.cpp
    pcsx2/common/MemorySettingsInterface.cpp
    pcsx2/common/ProgressCallback.cpp
    pcsx2/common/ReadbackSpinManager.cpp
    pcsx2/common/Semaphore.cpp
    pcsx2/common/SettingsWrapper.cpp
    pcsx2/common/SmallString.cpp
    pcsx2/common/StringUtil.cpp
    pcsx2/common/TextureDecompress.cpp
    pcsx2/common/Timer.cpp
    pcsx2/common/WAVWriter.cpp
    pcsx2/common/WindowInfo.cpp
    pcsx2/common/YAML.cpp

    # iOS platform layer (replaces HostSys.cpp and CocoaTools.mm)
    ios/platform/HostSys_iOS.cpp
    ios/platform/CocoaTools.mm
    ios/platform/AudioStream_iOS.mm
    ios/platform/Filesystem_iOS.mm

    # EXCLUDED — DO NOT ADD:
    # pcsx2/common/HostSys.cpp        (replaced by HostSys_iOS.cpp)
    # pcsx2/common/Perf.cpp           (Linux perf_event_open — iOS incompatible)
    # pcsx2/common/PrecompiledHeader.cpp (HEADER_FILE_ONLY)
    # pcsx2/common/emitter/*          (x86 only)
    # pcsx2/common/Windows/*          (Windows only)
    # pcsx2/common/Linux/*            (Linux only)
    # pcsx2/common/Darwin/*           (macOS only — we have iOS replacements)
    # pcsx2/common/CocoaTools.mm      (macOS — we have iOS replacement)
    # pcsx2/common/HTTPDownloaderCurl.cpp (no libcurl on iOS)
)

add_library(pcsx2_common STATIC ${PCSX2_COMMON_SOURCES})

target_include_directories(pcsx2_common PUBLIC
    ${CMAKE_SOURCE_DIR}/pcsx2
    ${CMAKE_SOURCE_DIR}/pcsx2/common
    ${CMAKE_SOURCE_DIR}/ios/platform
    ${CMAKE_SOURCE_DIR}/pcsx2/3rdparty/ryml/src
)

target_compile_definitions(pcsx2_common PUBLIC
    PCSX2_TARGET_IOS=1
    _M_ARM64=1
    DISABLE_VULKAN=1
    DISABLE_ANDROID=1
    TARGET_OS_IPHONE=1
)

target_link_libraries(pcsx2_common PUBLIC
    fmt::fmt
    fast_float
    cpuinfo
    ryml
    JPEG::JPEG
    PNG::PNG
    WebP::libwebp
)

# fast_float: disable __umulh usage on ARM64/clang (not available)
target_compile_definitions(pcsx2_common PUBLIC
    FASTFLOAT_ALLOWS_LEADING_PLUS=1
)

# ─── Apple Frameworks ──────────────────────────────────────────────────────
find_library(FW_METAL          Metal REQUIRED)
find_library(FW_METALKIT       MetalKit REQUIRED)
find_library(FW_AVFOUNDATION   AVFoundation REQUIRED)
find_library(FW_AUDIOTOOLBOX   AudioToolbox REQUIRED)
find_library(FW_UIKIT          UIKit REQUIRED)
find_library(FW_FOUNDATION     Foundation REQUIRED)
find_library(FW_QUARTZCORE     QuartzCore REQUIRED)
find_library(FW_COREGRAPHICS   CoreGraphics REQUIRED)


# ─── iOS Platform Layer ────────────────────────────────────────────────────
set(IOS_PLATFORM_SOURCES
    ios/platform/HostSys_iOS.cpp
    ios/platform/CocoaTools.mm
    ios/platform/AudioStream_iOS.mm
    ios/platform/Filesystem_iOS.mm
)

# ─── Main Executable ───────────────────────────────────────────────────────
add_executable(BionicSX2
    # Entry point placeholder — will be replaced with proper UIKit app entry in Phase 2
    ios/main_placeholder.mm
)

target_include_directories(BionicSX2 PRIVATE
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/ios/platform
)

target_link_libraries(BionicSX2 PRIVATE
    pcsx2_common
    ${FW_METAL}
    ${FW_METALKIT}
    ${FW_AVFOUNDATION}
    ${FW_AUDIOTOOLBOX}
    ${FW_UIKIT}
    ${FW_FOUNDATION}
    ${FW_QUARTZCORE}
    ${FW_COREGRAPHICS}
)

# ─── iOS Bundle Properties ─────────────────────────────────────────────────
set_target_properties(BionicSX2 PROPERTIES
    MACOSX_BUNDLE                   TRUE
    MACOSX_BUNDLE_INFO_PLIST        ${CMAKE_SOURCE_DIR}/ios/Info.plist
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
    XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED NO
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.bionics2.emulator"
    XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "14.2"
    XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS
        "${CMAKE_SOURCE_DIR}/ios/entitlements/BionicSX2.entitlements"
)

message(STATUS "✓ BionicSX2 iOS build configured")
message(STATUS "  Target:     iOS ${CMAKE_OSX_DEPLOYMENT_TARGET}+")
message(STATUS "  Arch:       ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
