# BionicSX2 — iOS CMake Toolchain File
# Usage: cmake -DCMAKE_TOOLCHAIN_FILE=cmake/ios.toolchain.cmake
#              -DPCSX2_TARGET_IOS=ON

set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_SYSTEM_PROCESSOR arm64)

# SDK
set(CMAKE_OSX_ARCHITECTURES "arm64")
set(CMAKE_OSX_DEPLOYMENT_TARGET "14.2" CACHE STRING "Minimum iOS version")
set(CMAKE_OSX_SYSROOT iphoneos)

# Compiler
set(CMAKE_C_COMPILER   /usr/bin/clang)
set(CMAKE_CXX_COMPILER /usr/bin/clang++)

# ARM64 detection — PCSX2 depends on this internally
add_compile_definitions(_M_ARM64=1)
add_compile_definitions(TARGET_OS_IPHONE=1)
add_compile_definitions(PCSX2_TARGET_IOS=1)

# Disable x86 JIT — non-negotiable on ARM64 iOS
add_compile_definitions(DISABLE_PCSX2_RECOMPILER=1)

# Disable Vulkan — Metal is the authoritative backend
add_compile_definitions(DISABLE_VULKAN=1)

# Disable Android paths
add_compile_definitions(DISABLE_ANDROID=1)

# Required Apple frameworks
set(IOS_FRAMEWORKS
    Metal
    MetalKit
    AVFoundation
    AudioToolbox
    UIKit
    Foundation
    CoreGraphics
    QuartzCore
)

foreach(FW ${IOS_FRAMEWORKS})
    find_library(FW_${FW} ${FW} REQUIRED)
endforeach()
