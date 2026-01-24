# Tanglaw

A comprehensive Flutter mobile application for accessing detailed medicine and pharmaceutical information. Tanglaw provides healthcare professionals, patients, and caregivers with easy access to drug information including usage guidelines, dosage recommendations, side effects, and other technical details.

## Features

- 🔍 **Search Medicine Database** - Quickly find information about various medicines and drugs
- 📋 **Detailed Drug Information** - Access comprehensive details including:
  - Drug names and classifications
  - Usage instructions and indications
  - Dosage recommendations
  - Side effects and contraindications
  - Drug interactions and warnings
- 📱 **Mobile-First Design** - Optimized for Android and iOS devices
- 🌐 **API Integration** - Real-time data fetching from pharmaceutical databases
- 💊 **Medicine Encyclopedia** - Browse through an extensive collection of medicines

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter](https://flutter.dev/docs/get-started/install) (SDK 3.10.7 or higher)
- [Dart](https://dart.dev/get-dart) (included with Flutter)
- Android Studio / Xcode (for mobile development)
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/tanglaw_app.git
   cd tanglaw_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   ```

### Configuration

Configure the API endpoint in your app by updating the API client settings in [lib/core/network/api_client.dart](lib/core/network/api_client.dart).

## Development

### Running Tests

```bash
flutter test
```

### Building for Production

**Android**
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## Technologies Used

- **Flutter** - UI framework for mobile development
- **Dart** - Programming language
- **HTTP** - For API communication and data fetching
- **Material Design** - UI/UX design system

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This application is intended for informational purposes only. Always consult with qualified healthcare professionals before making any medical decisions. The information provided should not be used as a substitute for professional medical advice, diagnosis, or treatment.

## Support

For support, please open an issue in the GitHub repository or contact the development team.

## Acknowledgments

- Flutter team for the amazing framework
- Contributors and maintainers
- Medical databases and pharmaceutical information providers