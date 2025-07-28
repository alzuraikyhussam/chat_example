# ChatApp - Modern Flutter Desktop Chat Application

A beautiful, modern, and elegant desktop chat application built with Flutter and GetX, inspired by WhatsApp Web with a cleaner and more attractive design.

## ✨ Features

### 🎨 Modern UI/UX
- **Clean Design**: Inspired by WhatsApp Web with modern improvements
- **Responsive Layout**: Optimized for desktop (Windows, Mac, Linux)
- **Dark/Light Theme**: Toggle between themes with persistent settings
- **Smooth Animations**: Beautiful transitions and micro-interactions
- **Material 3 Design**: Following latest Material Design principles

### 🔐 Authentication
- **Login Screen**: Email/password authentication with validation
- **Signup Screen**: User registration with form validation
- **Remember Me**: Persistent login state
- **Password Recovery**: Forgot password functionality
- **Animated Transitions**: Smooth screen transitions

### 💬 Chat Features
- **Real-time UI**: Modern chat interface with message bubbles
- **Contact List**: Scrollable sidebar with contact search
- **Message Status**: Read/unread indicators and timestamps
- **Emoji Picker**: Full emoji support for messages
- **File Attachments**: Support for file and image sharing (UI ready)
- **Online Status**: Real-time online/offline indicators

### ⚙️ Settings & Profile
- **Profile Management**: Edit name, email, and profile picture
- **Password Change**: Secure password update functionality
- **App Settings**: Notifications, sounds, auto-download options
- **Language Support**: Multi-language interface (English, Spanish, French, German)
- **Chat Customization**: Different chat bubble styles
- **Data Management**: Clear app data functionality

### 🏗️ Architecture
- **GetX State Management**: Reactive programming with GetX
- **MVC Pattern**: Clean separation of concerns
- **Modular Structure**: Organized code structure
- **Persistent Storage**: SharedPreferences for settings
- **Navigation**: Named routes with GetX

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── controllers/              # GetX Controllers (Business Logic)
│   ├── auth_controller.dart
│   ├── chat_controller.dart
│   ├── login_controller.dart
│   ├── signup_controller.dart
│   ├── profile_controller.dart
│   ├── settings_controller.dart
│   └── theme_controller.dart
├── models/                   # Data Models
│   ├── user_model.dart
│   └── message_model.dart
├── screens/                  # UI Screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── chat_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Reusable UI Components
│   ├── contact_list_item.dart
│   └── message_bubble.dart
├── themes/                   # App Themes
│   └── app_theme.dart
├── routes/                   # Navigation Routes
│   └── app_routes.dart
└── utils/                    # Utility Functions
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.5.4 or higher)
- Dart SDK
- Desktop development setup for your platform

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd chat_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Enable desktop support** (if not already enabled)
   ```bash
   flutter config --enable-windows-desktop
   flutter config --enable-macos-desktop
   flutter config --enable-linux-desktop
   ```

4. **Run the application**
   ```bash
   flutter run -d windows    # For Windows
   flutter run -d macos      # For macOS
   flutter run -d linux      # For Linux
   ```

## 📦 Dependencies

### Core Dependencies
- **get**: ^4.6.6 - State management and navigation
- **google_fonts**: ^6.2.1 - Beautiful typography
- **flutter_animate**: ^4.5.0 - Smooth animations
- **shared_preferences**: ^2.2.3 - Local storage

### UI & Media
- **emoji_picker_flutter**: ^2.2.0 - Emoji support
- **flutter_svg**: ^2.0.10+1 - SVG icons
- **lottie**: ^3.1.2 - Lottie animations
- **file_picker**: ^8.0.6 - File selection
- **image_picker**: ^1.1.2 - Image selection

### Utilities
- **intl**: ^0.19.0 - Internationalization

## 🎯 Key Features Walkthrough

### 1. Splash Screen
- Animated logo with gradient background
- Automatic login status check
- Smooth transition to appropriate screen

### 2. Authentication Flow
- **Login**: Email/password with validation and loading states
- **Signup**: Full registration form with terms acceptance
- **Persistent Sessions**: Remember login state across app restarts

### 3. Main Chat Interface
- **Sidebar**: Contact list with search and online indicators
- **Chat Area**: Message bubbles with timestamps and read receipts
- **Input Area**: Message composer with emoji picker and attachments

### 4. Profile Management
- **View/Edit Mode**: Toggle between viewing and editing profile
- **Profile Picture**: Camera integration for profile photos
- **Password Change**: Secure password update with validation

### 5. Settings Panel
- **Appearance**: Dark/light mode toggle and chat bubble styles
- **Chat Settings**: Notifications, sounds, and auto-download options
- **Language**: Multi-language support
- **Data Management**: Clear app data and logout

## 🎨 Design System

### Color Palette
- **Primary**: #00A884 (WhatsApp Green)
- **Secondary**: #25D366 (Accent Green)
- **Background Light**: #F7F8FA
- **Background Dark**: #111B21
- **Surface Light**: #FFFFFF
- **Surface Dark**: #202C33

### Typography
- **Font Family**: Inter (Google Fonts)
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Animations
- **Duration**: 300-600ms for most transitions
- **Curves**: Material motion curves (easeOut, elasticOut)
- **Types**: Fade, slide, scale animations

## 🔧 Customization

### Adding New Themes
1. Update `AppTheme` class in `lib/themes/app_theme.dart`
2. Add new color schemes and component themes
3. Update `ThemeController` to handle new theme

### Adding New Languages
1. Add language enum in `SettingsController`
2. Implement localization files
3. Update language selection dialog

### Extending Chat Features
1. Add new message types in `MessageModel`
2. Update `ChatController` for new functionality
3. Create corresponding UI components

## 🚀 Building for Production

### Windows
```bash
flutter build windows --release
```

### macOS
```bash
flutter build macos --release
```

### Linux
```bash
flutter build linux --release
```

## 📱 Future Enhancements

- [ ] Real backend integration
- [ ] Voice messages
- [ ] Video calls
- [ ] Group chats
- [ ] Message encryption
- [ ] Push notifications
- [ ] Cloud synchronization
- [ ] Advanced file sharing
- [ ] Message search
- [ ] Chat backups

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

Created with ❤️ using Flutter and GetX

---

**Note**: This is a UI-focused application with demo data. For production use, integrate with a real backend service for authentication, messaging, and data persistence.
