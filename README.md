# Quiet-on-Air

🎙️ **Quiet-on-Air** is a lightweight macOS menu-bar utility that automatically **pauses** your Apple TV or HomePod playback when your Mac’s microphone is in use, and **resumes** playback when you stop speaking—only if **Quiet-on-Air** initiated the pause.

Built with Swift 5.9 for macOS 13+.

---

## 💡 Overview

1. **Mic Detection**  
   Uses CoreAudio to observe the system’s default input device.  
2. **Shortcut Invocation**  
   - On mic **start** → runs the **Pause Media** shortcut  
   - On mic **stop** → runs the **Resume Media** shortcut (only if paused earlier)  
3. **Menu-Bar UI**  
   Custom icon indicates live mic status.

---

## 🧰 Requirements

- macOS 13 Ventura or later  
- **Shortcuts** app (built into macOS)  
- Two user-defined Shortcuts (case-sensitive names):
  1. **Pause Media**  
     - Action: *Control Home → Set Playback State → Pause*  
     - Targets your Apple TV/HomePod devices  
  2. **Resume Media**  
     - Action: *Control Home → Set Playback State → Play*  
     - Same targets  

- In Xcode **Signing & Capabilities**:
  - ✅ App Sandbox → Audio Input  
- In **Info.plist**:
  - Add **Privacy – Microphone Usage Description**  
    ```xml
    <key>NSMicrophoneUsageDescription</key>
    <string>Quiet-on-Air needs mic access to pause/resume media automatically.</string>
    ```

---

## 🚀 Installation & Usage

### A. Build from Source

1. **Clone the repo**  
   ```bash
   git clone https://github.com/JacksonR64/quietonair.git
   cd quietonair
   ```
2. **Open in Xcode**  
   ```bash
   open QuietOnAir.xcodeproj
   ```
3. **Build & Run** (⌘R)  
4. **Grant mic access** when prompted  
5. **Test**: play media on your Apple TV/HomePod, use dictation or FaceTime → playback pauses/resumes automatically

### B. Download Prebuilt App

1. Download the latest **QuietOnAir.app.zip** from the [Releases page](https://github.com/JacksonR64/quietonair/releases).  
2. Unzip and drag **Quiet On Air.app** into `/Applications`.  
3. Launch and approve the microphone prompt.  

---

## 📋 Detailed Shortcuts Setup

1. **Open Shortcuts**  
2. **Create “Pause Media”**  
   - Add action: **Control Home → Set Playback State → Pause**  
   - Select your Apple TV/HomePod accessories  
3. **Create “Resume Media”**  
   - Duplicate “Pause Media”, rename it, change state to **Play**  
4. **(Optional) Check Playback**  
   ```bash
   # control home get playback state
   ```  
   - Add action: **Control Home → Get Playback State**  
   - Add **If**:  
     - If **Playback State** is **Playing**, **Text** → `True`  
     - Otherwise, **Text** → `False`  
   - Name it **Check Playback** for use in the code’s `isPlaying()` check  

---

## 🚧 License & Intellectual Property

- **License:** MIT License © 2025 Jackson Rhoden ([LICENSE](LICENSE)).  
- **Usage:** You are free to use, modify, and redistribute this code under the MIT terms.  
- **Idea Protection:** While the code is open source, the underlying concept and branding (“Quiet-on-Air”) remain my original work. Please credit the author and do not publish a competing app under the same or confusingly similar name.

---

## 📦 Release History

- **v0.1.0** (2025-05-21)  
  - Initial public beta: mic-triggered pause/resume, custom menu-bar icon.

---

## 🧭 Roadmap & Future Plans

- **Preferences UI**  
  - Toggle global vs. per-app pause rules  
  - Whitelist specific communication apps (FaceTime, Zoom, Teams)  
  - Enable “mute” mode (lower volume instead of pause)  
- **Launch-at-Login** support  
- **Volume ducking** rather than full pause  
- **Multi-zone control**: pause/resume multiple AirPlay devices in sync  
- **Sparkle integration** for in-app updates  
- **Packaging & CI/CD**  
  - Automated builds & GitHub Actions  
  - Signed & notarized `.pkg` or `.dmg` installer  
- **Localization** & theming (dark mode, custom tint)

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
