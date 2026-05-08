// BionicSX2 — iOS Audio Stream Implementation
// Phase 2 implementation target
// Backend: AVAudioEngine / AudioUnit (CoreAudio)
// EXCLUDED: Oboe (Android-only — never use on iOS)
// Reference: PCSX2 macOS CoreAudio backend → adapted for iOS AVAudioSession

#include <AudioToolbox/AudioToolbox.h>

// TODO Phase 2: Initialize AVAudioSession before any audio work
// This step is MANDATORY on iOS — absent on macOS
// Category: AVAudioSessionCategoryPlayback
// Mode:     AVAudioSessionModeDefault
// Options:  AVAudioSessionCategoryOptionMixWithOthers (optional)
//
// Objective-C call — move to AudioStream_iOS.mm if AVAudioSession
// Objective-C headers are needed directly here.
// For now: stub with correct TODO for Phase 2 implementation.
void AudioStream_InitSession() {
    // TODO Phase 2: implement in .mm file using AVAudioSession:
    // [[AVAudioSession sharedInstance]
    //     setCategory:AVAudioSessionCategoryPlayback
    //     error:nil];
    // [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

// TODO Phase 2: Create and start AVAudioEngine
// macOS used: AudioUnit directly
// iOS: AVAudioEngine wraps AudioUnit — identical output quality
// Sample rate: 48000 Hz (PS2 SPU2 native)
// Format: PCM float32, stereo (2 channels)
void AudioStream_Start() {
    // TODO Phase 2: AVAudioEngine setup
    // AVAudioEngine* engine = [[AVAudioEngine alloc] init];
    // AVAudioPlayerNode* player = [[AVAudioPlayerNode alloc] init];
    // [engine attachNode:player];
    // AVAudioFormat* fmt = [[AVAudioFormat alloc]
    //     initStandardFormatWithSampleRate:48000 channels:2];
    // [engine connect:player to:engine.mainMixerNode format:fmt];
    // [engine startAndReturnError:nil];
}

// TODO Phase 2: Stop and release AVAudioEngine
void AudioStream_Stop() {
    // TODO Phase 2: [engine stop];
}

// TODO Phase 2: Push audio samples from SPU2 to AVAudioEngine buffer
// Called from SPU2 thread — must be thread-safe
void AudioStream_WriteSamples(const float* samples, int count) {
    // TODO Phase 2: schedule buffer on AVAudioPlayerNode
    // Must handle buffer underrun gracefully — no crash on starvation
}
