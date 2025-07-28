# ChatApp - Flutter Desktop Chat Application

A modern, elegant desktop chat application inspired by WhatsApp Web, built with Flutter and GetX. This app provides a complete UI foundation ready for integration with your custom API backend.

## Features

- 🎨 **Modern WhatsApp Web-inspired UI**
- 🌙 **Light/Dark theme support**
- 💬 **Real-time messaging interface**
- 📁 **File upload/download support**
- 🔔 **Push notifications**
- 💾 **Offline message persistence**
- 🔐 **Authentication system**
- ⚡ **WebSocket real-time communication**
- 📱 **Responsive desktop layout**

## Screenshots

The app closely matches WhatsApp Web's design with:
- Fixed-width sidebar for contacts
- Chat header with user status
- Message bubbles with timestamps
- Input area with emoji picker and attachments

## Project Structure

```
lib/
├── config/
│   └── api_config.dart           # API endpoints and configuration
├── controllers/
│   ├── auth_controller.dart      # Authentication logic
│   ├── chat_controller.dart      # Chat functionality
│   ├── login_controller.dart     # Login screen logic
│   ├── profile_controller.dart   # Profile management
│   ├── settings_controller.dart  # App settings
│   ├── signup_controller.dart    # Registration logic
│   └── theme_controller.dart     # Theme management
├── models/
│   ├── message_model.dart        # Message data model
│   └── user_model.dart          # User data model
├── routes/
│   └── app_routes.dart          # Navigation routes
├── screens/
│   ├── chat_screen.dart         # Main chat interface
│   ├── login_screen.dart        # Login screen
│   ├── profile_screen.dart      # User profile
│   ├── settings_screen.dart     # App settings
│   ├── signup_screen.dart       # Registration screen
│   └── splash_screen.dart       # Splash screen
├── services/
│   ├── api_service.dart         # HTTP API client
│   ├── file_service.dart        # File upload/download
│   ├── local_storage_service.dart # Local data persistence
│   ├── notification_service.dart # Push notifications
│   └── websocket_service.dart   # Real-time communication
├── themes/
│   └── app_theme.dart          # App theming
└── main.dart                   # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Your custom API backend
- Firebase project (for push notifications)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd chat_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for Hive adapters)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure your API endpoints**
   Edit `lib/config/api_config.dart`:
   ```dart
   static const String baseUrl = 'https://your-api-domain.com/api/v1';
   static const String websocketUrl = 'wss://your-api-domain.com/ws';
   ```

5. **Run the application**
   ```bash
   flutter run -d windows  # For Windows
   flutter run -d macos    # For macOS
   flutter run -d linux    # For Linux
   ```

## API Integration Guide

### 1. Authentication Endpoints

Your backend should implement these endpoints:

```
POST /auth/login
POST /auth/register
POST /auth/refresh
POST /auth/logout
POST /auth/forgot-password
POST /auth/reset-password
```

**Example Login Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Expected Response:**
```json
{
  "access_token": "jwt_access_token",
  "refresh_token": "jwt_refresh_token",
  "user": {
    "id": "user_id",
    "name": "John Doe",
    "email": "user@example.com",
    "profile_picture": "https://example.com/avatar.jpg",
    "is_online": true,
    "last_seen": "2024-01-01T12:00:00Z"
  }
}
```

### 2. Chat Endpoints

```
GET /chat/conversations
GET /chat/messages
POST /chat/send
POST /chat/mark-read
DELETE /chat/delete
PUT /chat/edit
```

**Example Send Message Request:**
```json
{
  "conversation_id": "conv_123",
  "content": "Hello, world!",
  "type": "text"
}
```

### 3. File Upload Endpoints

```
POST /files/upload
GET /files/download/:id
DELETE /files/:id
```

**File Upload Response:**
```json
{
  "file_id": "file_123",
  "file_name": "document.pdf",
  "file_url": "https://example.com/files/document.pdf",
  "mime_type": "application/pdf",
  "file_size": 1024000
}
```

### 4. WebSocket Events

Your WebSocket server should handle these events:

**Client to Server:**
- `connect` - User connects
- `join_room` - Join conversation room
- `new_message` - Send new message
- `typing` - User is typing
- `stop_typing` - User stopped typing

**Server to Client:**
- `new_message` - Receive new message
- `message_read` - Message read receipt
- `user_online` - User came online
- `user_offline` - User went offline
- `typing` - Someone is typing
- `stop_typing` - Someone stopped typing

## Real-time Messaging Setup

The app uses Socket.IO for real-time communication. Your backend should:

1. **Authenticate WebSocket connections** using JWT tokens
2. **Implement room-based messaging** for conversations
3. **Handle typing indicators** and user presence
4. **Send message read receipts**

Example WebSocket message format:
```json
{
  "id": "msg_123",
  "conversation_id": "conv_456",
  "sender_id": "user_789",
  "content": "Hello!",
  "type": "text",
  "timestamp": "2024-01-01T12:00:00Z",
  "is_read": false
}
```

## Push Notifications

### Firebase Setup

1. **Create a Firebase project**
2. **Add your app to Firebase**
3. **Download configuration files:**
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)

4. **Configure your backend** to send FCM messages:
   ```json
   {
     "to": "device_token",
     "notification": {
       "title": "New Message",
       "body": "John: Hello there!"
     },
     "data": {
       "conversation_id": "conv_123",
       "sender_name": "John Doe"
     }
   }
   ```

## Local Storage & Offline Support

The app uses Hive for local storage:

- **Messages** are cached locally for offline viewing
- **User data** persists between app launches
- **Settings** are stored locally
- **Pending messages** are queued when offline

## File Upload Implementation

The `FileService` handles:

- **Image/file selection** with size validation
- **Progress tracking** during uploads
- **File type restrictions** based on configuration
- **Automatic compression** for images
- **Download management** with progress

## Customization

### Theming

Modify `lib/themes/app_theme.dart` to customize:
- Colors and gradients
- Typography and fonts
- Component styles
- Light/dark mode variants

### API Configuration

Update `lib/config/api_config.dart` for:
- Base URLs and endpoints
- File size limits
- Timeout settings
- WebSocket events

### Features

The modular architecture allows easy:
- Addition of new screens
- Integration of new APIs
- Customization of UI components
- Extension of functionality

## Production Deployment

### Security Considerations

1. **Use HTTPS** for all API communications
2. **Implement proper JWT validation**
3. **Sanitize user inputs** on the backend
4. **Use secure WebSocket connections** (WSS)
5. **Validate file uploads** on the server

### Performance Optimization

1. **Implement message pagination** for large conversations
2. **Use image compression** for file uploads
3. **Cache frequently accessed data**
4. **Optimize WebSocket reconnection logic**
5. **Implement proper error handling**

### Backend Requirements

Your API should support:

- **JWT authentication** with refresh tokens
- **Real-time WebSocket** connections
- **File upload/download** with progress tracking
- **Push notification** delivery
- **Message persistence** and history
- **User presence** and online status
- **Message read receipts**
- **Typing indicators**

## API Documentation Template

Document your API endpoints with:

```yaml
openapi: 3.0.0
info:
  title: ChatApp API
  version: 1.0.0
paths:
  /auth/login:
    post:
      summary: User login
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                password:
                  type: string
      responses:
        '200':
          description: Login successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  access_token:
                    type: string
                  refresh_token:
                    type: string
                  user:
                    $ref: '#/components/schemas/User'
```

## Testing

Run tests with:
```bash
flutter test
```

For integration testing:
```bash
flutter drive --target=test_driver/app.dart
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support:
- Create an issue in the repository
- Check the documentation
- Review the example API implementations

---

**Note:** This is a UI-focused Flutter application. You'll need to implement the backend API endpoints and WebSocket server according to the specifications above to have a fully functional chat application.
