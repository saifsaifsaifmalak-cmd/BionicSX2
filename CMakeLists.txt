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

# ─── Apple Frameworks ──────────────────────────────────────────────────────
find_library(FW_METAL          Metal          REQUIRED)
find_library(FW_METALKIT       MetalKit       REQUIRED)
find_library(FW_AVFOUNDATION   AVFoundation   REQUIRED)
find_library(FW_AUDIOTOOLBOX   AudioToolbox   REQUIRED)
find_library(FW_UIKIT          UIKit          REQUIRED)
find_library(FW_FOUNDATION     Foundation     REQUIRED)
find_library(FW_QUARTZCORE     QuartzCore     REQUIRED)
find_library(FW_COREGRAPHICS   CoreGraphics   REQUIRED)

set(APPLE_FRAMEWORKS
    ${FW_METAL}
    ${FW_METALKIT}
    ${FW_AVFOUNDATION}
    ${FW_AUDIOTOOLBOX}
    ${FW_UIKIT}
    ${FW_FOUNDATION}
    ${FW_QUARTZCORE}
    ${FW_COREGRAPHICS}
)

# ─── iOS Platform Layer ────────────────────────────────────────────────────
set(IOS_PLATFORM_SOURCES
    ios/platform/HostSys_iOS.cpp
    ios/platform/CocoaTools.mm
    ios/platform/AudioStream_iOS.cpp
    ios/platform/Filesystem_iOS.cpp
)

# ─── Main Executable ───────────────────────────────────────────────────────
add_executable(BionicSX2
    ${IOS_PLATFORM_SOURCES}
)

target_include_directories(BionicSX2 PRIVATE
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/ios/platform
)

target_link_libraries(BionicSX2 PRIVATE
    ${APPLE_FRAMEWORKS}
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
