# ClimAIte 🌦️
Your AI-Powered Weather Companion

**ClimAIte** is a cross-platform weather application built using **Flutter**, designed for both iOS and Android. The app combines reliable weather data from OpenMateo with the intelligence of Google's Gemini AI to provide a unique and engaging weather experience.

---

## 🌟 Features

- **Modern & Sleek Design:**
  A visually appealing interface that aligns with the app's purpose.

- **Real-Time Weather Updates:**
  Accurate and up-to-date weather data from **OpenMateo API**.

- **AI-Powered Insights:**
  Leverages **Google's Gemini AI** to provide:
  - Personalized weather tips.
  - Future weather trend predictions.
  - Unique and fun weather facts.

- **Cross-Platform:**
  Optimized for both Android and iOS platforms using Flutter.

- **User-Friendly Experience:**
  Interactive animations, intuitive navigation, and customization options for a seamless user experience.

---

## 🚀 Tech Stack

- **Framework:** Flutter (Dart)
- **AI Integration:** Google Gemini AI
- **Weather API:** OpenMateo
- **State Management:** BLoC Pattern
- **Local Storage:** SharedPreferences
- **CI/CD:** GitHub Actions

---

## 🎨 Design

The app features a **modern theme** inspired by the essence of weather:
- **Primary Color:** Cool Blue (#2196F3) – representing clear skies.
- **Accent Color:** Warm Yellow (#FFC107) – symbolizing sunlight.
- **Background:** Light Grey (#F5F5F5) for a clean, minimalistic look.

---

## 🛠️ Setup and Installation

### Prerequisites
- Install Flutter SDK: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Obtain API keys:
  - [OpenMateo](https://open-meteo.com/)
  - [Google Gemini AI](https://ai.google.dev/)

### Clone the Repository
```bash
git clone https://github.com/justkelvin/climAIte.git
cd climAIte
```

### Install Dependencies
```bash
flutter pub get
```

### Development Setup
Run the app with required environment variables:
```bash
flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key
```

### Release Build
For release builds, ensure you have:
1. Generated a keystore file
2. Created `android/key.properties` with your signing configuration
3. Set up the required GitHub Secrets for CI/CD

Build release APK locally:
```bash
flutter build apk --release --dart-define=GEMINI_API_KEY=your_gemini_api_key
```

---

## 📦 CI/CD Pipeline

The project uses GitHub Actions for continuous integration and deployment. The pipeline:
- Runs tests and analysis
- Builds release artifacts
- Handles signing configuration
- Manages secrets securely

### Required Secrets
Set up the following secrets in your GitHub repository:
- `GEMINI_API_KEY`: Your Gemini AI API key
- `KEYSTORE_BASE64`: Base64 encoded keystore file
- `KEYSTORE_PASSWORD`: Keystore password
- `KEY_PASSWORD`: Key password
- `KEY_ALIAS`: Key alias

---

## 🔒 Security

- Environment variables are handled securely using compile-time configurations
- No sensitive data is stored in the repository
- Release builds are properly signed
- CI/CD pipeline uses GitHub Secrets for sensitive data

---

## 📚 Future Roadmap

- Implement **voice interactions** using Gemini AI
- Add **multi-language support** for global users
- Introduce **customizable widgets** for home screen integration
- Support offline mode with **cached weather data**
- Enhance CI/CD pipeline with automated testing

---

## 🤝 Contribution

We welcome contributions! Follow these steps:

1. Fork the repo
2. Create a feature branch
3. Set up local development environment with required environment variables
4. Make your changes
5. Run tests and ensure CI passes
6. Submit a pull request with a clear description

### Pull Request Guidelines
- Ensure all tests pass
- Update documentation as needed
- Follow the existing code style
- Include appropriate test coverage
- Keep changes focused and atomic

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Maintainer
- [@justkelvin](https://github.com/justkelvin)

Last Updated: 2024-12-23
```

Key updates made to the documentation:
1. Added CI/CD pipeline section
2. Updated setup instructions with environment variables
3. Added security section
4. Updated tech stack to reflect current choices
5. Added detailed release build instructions
6. Updated contribution guidelines
7. Added maintainer information
8. Added last updated date
9. Included GitHub Secrets configuration
10. Updated development setup with new environment variable handling
