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
   Custom icon for basic controls and configuration 

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

### Option A: Download Prebuilt App

1. Download the latest **Quiet On Air.app.zip** from the [Releases page](https://github.com/JacksonR64/quiet-on-air/releases).  
2. Unzip and drag **Quiet On Air.app** into `/Applications`.  
3. Launch it—macOS may block unsigned apps; see **Security & Privacy** below.  
4. Grant permission when prompted.

### Option B: Build from Source

1. **Clone the repo**  
   ```bash
   git clone https://github.com/JacksonR64/quiet-on-air.git
   cd quiet-on-air
   ```
2. **Open in Xcode**  
   ```bash
   open QuietOnAir.xcodeproj
   ```
3. **Enable entitlements** as per **Requirements**.  
4. **Build & Run** (⌘R).  
5. **Grant mic access** when prompted.

---

## 🔒 Security & Privacy

On first launch, macOS may block **Quiet On Air** since it is not notarized by Apple. To allow it:

1. Go to **System Settings** → **Privacy & Security**.  
2. Scroll down to the **Security** section.  
3. Under **Allow apps downloaded from**, locate the message stating **Quiet On Air** was blocked.  
4. Click **Open Anyway** next to that message.  
5. Then launch **Quiet On Air** again via Finder (right-click ↦ **Open** if needed).

This grants the necessary permission so the app can run without further prompts.

---

## 📋 Detailed Shortcuts Setup

1. **Open Shortcuts**  
2. **Create “Pause Media”**  
   - Add action: **Control Home → Set Playback State → Pause**  
   - Select your Apple TV/HomePod accessories  
3. **Create “Resume Media”**  
   - Duplicate “Pause Media”, rename it, change state to **Play**  
4. **Optional: Check Playback**  
   - Add action: **Control Home → Get Playback State**  
   - Add **If**:  
     - If **Playback State** is **Playing**, **Text** → `True`  
     - Otherwise, **Text** → `False`  
   - Name it **Check Playback** for use in the code’s `isPlaying()` check  

---

## 🚧 Known Issues & Limitations

- **Homebridge plugin dependency**  
  Current playback-state detection relies on the Homebridge “Apple TV Enhanced” plugin. Users without Homebridge cannot use the auto-pause feature.  
- **Native Dictation support**  
  Apple’s built-in Dictation feature does not set the standard CoreAudio “in use” flag currently used by **Quiet-on-Air**, so media playback will not pause/resume when using native dictation.  
- **Menu-Bar Icon shape**  
  The current icon is a full square image. We plan to update it to a proper rounded-corner asset in a future release.

These issues are on our radar and planned for upcoming updates.

---

## ☕ Support

Quiet-on-Air is free and open-source, but code signing and notarization require a paid Apple Developer Program membership (USD $99/year). If you'd like to help cover the cost of a Developer ID certificate and make future releases smoother (no Gatekeeper prompts), consider buying me a coffee:

[☕ Buy Me a Coffee](https://www.buymeacoffee.com/YourProfile)

Your support will directly contribute to:
- Signing and notarizing releases so they run without warnings.  
- Hosting and bandwidth costs for binary distribution.  
- Ongoing development and new features.

---

## 📦 Release History

- **v0.1.0** (2025-05-21)  
  - Initial public beta: mic-triggered pause/resume, custom menu-bar icon.

---

## 🧭 Roadmap & Future Plans

- **Native HomeKit integration** (remove Homebridge dependency)  
- **Rounded-corner menu-bar icon** (improve branding)  
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

---

## 🚩 License & Intellectual Property

MIT License © 2025 Jackson Rhoden. See [LICENSE](LICENSE).  
Please credit the author and do not publish a competing app under the same or confusingly similar name.
