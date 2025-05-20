# QuietOnAir

🎙️ A tiny macOS menu bar utility that pauses/resumes media playback on your Apple TV or HomePods when your Mac mic is in use.

Built in Swift 5.9 – macOS 13+

---

## 💡 How It Works

- Detects microphone activity using CoreAudio.
- Runs Apple Shortcuts:
  - When mic becomes active → runs `Pause Media`
  - When mic is released → runs `Resume Media` (only if it was paused by the app)

---

## 🧰 Requirements

- macOS 13 Ventura or newer
- Two Shortcuts named exactly:
  - `Pause Media` – pauses HomePod or Apple TV playback
  - `Resume Media` – resumes playback
- Enable the following in app settings:
  - ✅ App Sandbox › Audio Input
  - ✅ `NSMicrophoneUsageDescription` in `Info.plist`

---

## 🚀 Installation

- Open `QuietOnAir.xcodeproj` in Xcode
- Build and run

> 🔒 On first launch, macOS will prompt for microphone access.

---

## 📦 Version History

### v0.1.0 (Initial Release)
- Menu bar app that observes mic activity.
- Pauses and resumes media via Apple Shortcuts.
- Only resumes media if it was previously paused by QuietOnAir.

---

## 🧭 Roadmap

- [ ] Menu bar toggle: Enable/disable pause/resume feature
- [ ] Alternate mode: Mute instead of Pause (requires new Shortcut)
- [ ] Launch at login support
- [ ] Hide from Dock (menu bar only)
- [ ] Release downloadable `.app` version

---

## 📝 License

MIT License (Add full LICENSE file if needed)

---

## 🛠 Developer Notes

This is a hobby utility for personal use, feel free to fork and expand.
