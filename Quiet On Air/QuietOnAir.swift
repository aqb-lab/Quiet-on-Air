//  QuietOnAir.swift
//  Swift 5.9 – macOS 13+
//
//  A tiny menu-bar utility that pauses your Apple TV / HomePods whenever the
//  Mac microphone is in use, and resumes playback when it’s released.
//
//  HOW IT WORKS:
//  • Observes AVCaptureDevice.isInUseByAnotherApplication (orange-mic-dot flag).
//  • When TRUE  → runs  `shortcuts run "Pause Media"`
//    When FALSE → runs  `shortcuts run "Resume Media"`
//
//  REQUIREMENTS:
//  • Two Shortcuts named “Pause Media” and “Resume Media” that control your
//    Apple TV / HomePods (via the HomeKit action “Set Playback State”).
//  • App Sandbox › Audio Input enabled, plus NSMicrophoneUsageDescription key.
//  • macOS 13 Ventura or newer.

import SwiftUI
import AVFoundation
import CoreAudio

final class QuietOnAirStatus: ObservableObject {
    @Published var active: Bool = false
    static let shared = QuietOnAirStatus()
}

@main
struct QuietOnAirApp: App {
    @StateObject private var status = QuietOnAirStatus.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra {
            Button("Pause Media")  { Commands.pause()  }
            Button("Resume Media") { Commands.resume() }
            Divider()
            Button("Quit") { NSApp.terminate(nil) }
        } label: {
            Image("MenuBarIcon")
                .renderingMode(.template)
        }
    }
}

enum Commands {
    private static func run(_ shortcut: String) {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
        proc.arguments = ["run", shortcut]
        try? proc.run()
    }
    static func pause()  { run("Pause Media")  }
    static func resume() { run("Resume Media") }

    static func isPlaying() -> Bool {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
        proc.arguments = ["run", "Check Playback", "--output-path", "-"]
        let pipe = Pipe()
        proc.standardOutput = pipe
        do {
            try proc.run()
            proc.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let str = String(data: data, encoding: .utf8)?
                          .trimmingCharacters(in: .whitespacesAndNewlines) {
                return str.lowercased() == "true"
            }
        } catch {
            // Ignore errors silently
        }
        return false
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var monitor: MicMonitor?

    func applicationDidFinishLaunching(_ notification: Notification) {
        monitor = MicMonitor()
    }
}

final class MicMonitor: NSObject {
    private var defaultDeviceID: AudioDeviceID = 0
    private var listenerAddress = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyDeviceIsRunningSomewhere,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain)
    private var listenerBlock: AudioObjectPropertyListenerBlock!
    private var didPause = false

    override init() {
        super.init()
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultInputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain)
        var size = UInt32(MemoryLayout<AudioDeviceID>.size)
        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            0, nil,
            &size,
            &defaultDeviceID)

        listenerBlock = { [weak self] _, _ in
            guard let self = self else { return }
            var isRunning: UInt32 = 0
            var runSize = UInt32(MemoryLayout<UInt32>.size)
            AudioObjectGetPropertyData(
                self.defaultDeviceID,
                &self.listenerAddress,
                0, nil,
                &runSize,
                &isRunning)
            self.handleMic(inUse: isRunning != 0)
        }

        AudioObjectAddPropertyListenerBlock(
            defaultDeviceID,
            &listenerAddress,
            DispatchQueue.main,
            listenerBlock)

        listenerBlock(defaultDeviceID, &listenerAddress)
    }

    private func handleMic(inUse: Bool) {
        if inUse {
            if Commands.isPlaying() {
                Commands.pause()
                didPause = true
            }
        } else if didPause {
            Commands.resume()
            didPause = false
        }
        DispatchQueue.main.async {
            QuietOnAirStatus.shared.active = inUse
        }
    }

    deinit {
        AudioObjectRemovePropertyListenerBlock(
            defaultDeviceID,
            &listenerAddress,
            DispatchQueue.main,
            listenerBlock)
    }
}
