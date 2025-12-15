# 🎛️ DSP Lab – Digital Signal Processing Application

![Flutter](https://img.shields.io/badge/Flutter-3.19-blue)
![GetX](https://img.shields.io/badge/GetX-4.8-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey)

> **Interactive Digital Signal Processing Laboratory in Your Pocket**  
An educational Flutter application for visualizing, analyzing, and understanding DSP concepts through interactive visualizations.

![DSP Lab Banner](https://via.placeholder.com/1200x400/4A5568/FFFFFF?text=DSP+LAB+-+Interactive+Signal+Processing)

---

## 🚀 Features

### 📊 1. Signal Generator Module
- Multiple Waveform Types: **Sine, Cosine, Square, Triangle, Sawtooth, Noise, Chirp**
- Real-time Parameter Control: **Frequency, Amplitude, Phase, Noise Level**
- Interactive Visualization: Animated waveforms with current time indicator
- Export Capability: Generate and export signal data as **CSV**

### 🔬 2. FFT Spectrum Analyzer
- Real-time Frequency Analysis: Compute and display FFT of signals
- Multiple Window Functions: **Hamming, Hann, Blackman, Flattop, Rectangular**
- Peak Detection: Automatic identification of dominant frequencies
- Dual View: Simultaneous **time-domain** and **frequency-domain** visualization

### 🎤 3. Voice DSP Module
- Audio Recording & Playback: Real-time audio processing
- Waveform Visualization: Dynamic audio waveform display
- Frequency Spectrum: Real-time FFT of audio signals
- Audio Filters: **Low-pass, High-pass, Echo, Reverb, Chorus**
- Audio Metrics: Volume, Pitch, RMS, Zero Crossing Rate
- Export Analysis: Generate comprehensive audio analysis reports

### 🧠 4. AI Insights Module *(Coming Soon)*
- Pattern Recognition: ML-based signal classification
- Anomaly Detection: Identify unusual patterns in signals
- Predictive Analysis: Forecast signal behavior
- Smart Recommendations: AI-powered processing suggestions

### 🎨 5. Animated Visualizations
- Real-time Wave Animations: Smooth, hardware-accelerated rendering
- Interactive Controls: Touch and drag to manipulate signals
- Educational Animations: Step-by-step DSP concept demonstrations
- 3D Visualizations: Frequency–time–amplitude plots

### ⚙️ 6. Professional Features
- Dark / Light Theme with dynamic switching
- Responsive Design for mobile, tablet, and desktop
- GetX State Management
- High-performance CustomPainters
- Route-based Navigation

---

## 📱 Screenshots

| Signal Generator | FFT Analyzer | Voice DSP |
|------------------|-------------|-----------|
| ![](https://via.placeholder.com/300x600/1E40AF/FFFFFF?text=Signal+Generator) | ![](https://via.placeholder.com/300x600/059669/FFFFFF?text=FFT+Analyzer) | ![](https://via.placeholder.com/300x600/DC2626/FFFFFF?text=Voice+DSP) |

| Settings | Dashboard | Animations |
|----------|-----------|------------|
| ![](https://via.placeholder.com/300x600/7C3AED/FFFFFF?text=Settings) | ![](https://via.placeholder.com/300x600/F59E0B/FFFFFF?text=Dashboard) | ![](https://via.placeholder.com/300x600/10B981/FFFFFF?text=Animations) |

---

## 🛠️ Tech Stack

### Core Framework
- **Flutter 3.19+** – Cross-platform framework
- **Dart 3.3+** – Programming language
- **GetX 4.8+** – State management, routing, DI

### Audio Processing
- `record` – Audio recording
- `flutter_sound` – Audio playback & processing
- `audio_waveforms` – Waveform visualization
- `mic_stream` – Real-time microphone access

### UI & Design
- Material Design 3
- CustomPaint for high-performance graphics
- Hardware-accelerated animations
- Fully responsive layouts

### Architecture
- GetX MVC Pattern
- Dependency Injection
- Named Route Management
- Dynamic Theme Management

---

## 📁 Project Structure

```text
lib/
├── main.dart
├── app/
│   ├── core/
│   │   ├── themes/
│   │   └── constants/
│   ├── data/
│   │   ├── models/
│   │   └── services/
│   ├── modules/
│   │   ├── dashboard/
│   │   ├── signal_generator/
│   │   ├── fft_analyzer/
│   │   ├── voice_dsp/
│   │   ├── ai_insights/
│   │   └── animations/
│   ├── widgets/
│   └── routes/
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
└── test/
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK **3.19+**
- Dart **3.3+**
- Android Studio / VS Code
- Xcode (for iOS)
- Chrome (for Web)

### Installation

```bash
git clone https://github.com/yourusername/dsp-lab.git
cd dsp-lab
flutter pub get
```

### Run

```bash
flutter run            # default
flutter run -d ios     # iOS
flutter run -d chrome  # Web
```

### Build

```bash
flutter build apk --release
flutter build ios --release
flutter build web --release
```

---

## 📖 Usage Guide

### Signal Generator
- Select waveform type
- Adjust frequency, amplitude, phase
- Add noise
- Observe real-time animation
- Export signal data

### FFT Analyzer
- Generate or input signal
- Select window function
- View time & frequency domain
- Detect peak frequencies

### Voice DSP
- Grant microphone permission
- Record voice/audio
- Apply filters
- Analyze metrics
- Export reports

### Settings
- Toggle light/dark theme
- Configure audio parameters
- Reset settings

---

## 🧪 Educational Applications

### For Students
- Visual learning of DSP concepts
- Interactive experimentation
- Real-world signal examples
- Self-paced tutorials

### For Educators
- Classroom demonstrations
- DSP lab assignments
- Student projects
- Research prototyping

### For Developers
- Advanced Flutter techniques
- GetX architecture reference
- CustomPaint examples
- Real-time audio processing

---

## 📚 DSP Concepts Covered

- Sampling Theorem (Nyquist–Shannon)
- ADC / DAC
- Aliasing & Quantization
- Time & Frequency Domain Analysis
- FFT & Windowing
- FIR / IIR Filters
- Convolution & Correlation
- Audio Effects & Analysis
- Signal Classification

---

## 🎓 Learning Resources

- DSP Guide (Free online textbook)
- MIT OpenCourseWare – DSP
- 3Blue1Brown – Fourier Transform

---

## 🤝 Contributing

```bash
git checkout -b feature/amazing-feature
git commit -m "Add amazing feature"
git push origin feature/amazing-feature
```

- Add tests
- Update documentation
- Follow code style
- Avoid breaking changes

---

## 📄 License

Licensed under the **MIT License**.

---

## 📞 Support

- 📧 Email: **support@dsplab.app**
- 🐛 GitHub Issues
- 💬 Discord Community

---

## 🌟 Show Your Support

If you find this project helpful, please give it a ⭐ on GitHub!

