# Local LAN Setup Guide

This guide helps you set up the Flutter chat app to work with your local LAN network without requiring Firebase or any external services.

## 🚀 Quick Setup

### 1. Configure Your Server IP

Edit `lib/config/environment_config.dart`:

```dart
static const Map<String, String> developmentConfig = {
  'baseUrl': 'http://YOUR_SERVER_IP:3000/api/v1',        // Replace with your server IP
  'websocketUrl': 'ws://YOUR_SERVER_IP:3000/ws',         // Replace with your server IP
  'fileUploadUrl': 'http://YOUR_SERVER_IP:3000/api/v1/files',
};
```

**Example:**
- If your server is running on `192.168.1.100:3000`
- Update the IPs to `192.168.1.100`

### 2. Find Your Server IP

**On Windows:**
```cmd
ipconfig
```

**On macOS/Linux:**
```bash
ifconfig
# or
ip addr show
```

**Common IP ranges:**
- `192.168.1.x` (most home routers)
- `192.168.0.x` (alternative home setup)
- `10.0.0.x` (corporate networks)

### 3. Test Connection

Use the built-in network tools in the app:
1. Open **Settings**
2. Go to **Network & Development**
3. Tap **Test Connection**
4. If it fails, tap **Find Server** to auto-discover

## 📱 Notifications Setup

### Local Notifications (No Firebase Needed)

The app uses **local system notifications** that work entirely offline:

✅ **What works:**
- Desktop notifications when app is in background
- Sound and vibration alerts
- Click-to-open functionality
- Customizable notification settings

❌ **What doesn't work without Firebase:**
- Push notifications when app is completely closed
- Remote push notifications from server
- Cross-device notification sync

### Notification Types

1. **System Notifications**
   - Shown when app is minimized/background
   - Native OS notifications (Windows/macOS/Linux)
   - Customizable sound and vibration

2. **In-App Notifications**
   - Shown when app is active
   - GetX snackbars and dialogs
   - Real-time message alerts

3. **WebSocket Notifications**
   - Real-time message delivery
   - Typing indicators
   - User online/offline status

## 🔧 Configuration Options

### Environment Settings

```dart
// In lib/config/environment_config.dart
static const Environment currentEnvironment = Environment.development;
```

**Development Mode Features:**
- Extended connection timeouts for local network
- Detailed network logging
- Connection test utilities
- Auto-server discovery

### Network Settings

```dart
static const int connectionTimeout = 10000; // 10 seconds for local network
static const int receiveTimeout = 10000;
static const int sendTimeout = 10000;
static const bool enableLogging = true;
```

## 🛠️ Troubleshooting

### Connection Issues

**Problem:** Cannot connect to server
**Solutions:**
1. Check server is running: `curl http://YOUR_IP:3000/api/v1/health`
2. Verify firewall settings allow port 3000
3. Ensure devices are on same network
4. Use **Find Server** feature in app settings

**Problem:** WebSocket connection fails
**Solutions:**
1. Check WebSocket endpoint is accessible
2. Verify server supports WebSocket connections
3. Test with: `ws://YOUR_IP:3000/ws`

### Notification Issues

**Problem:** No notifications appearing
**Solutions:**
1. Check notification permissions in OS settings
2. Test with **Test Notification** in app settings
3. Verify app is not in Do Not Disturb mode
4. Check notification service initialization

**Problem:** Notifications not clickable
**Solutions:**
1. Ensure app is registered as default handler
2. Check notification payload format
3. Verify routing configuration

## 📋 Backend Requirements

Your local server should provide these endpoints:

### Health Check
```
GET /api/v1/health
Response: 200 OK
```

### Authentication
```
POST /api/v1/auth/login
POST /api/v1/auth/register
POST /api/v1/auth/refresh
```

### Chat APIs
```
GET /api/v1/chat/conversations
GET /api/v1/chat/messages
POST /api/v1/chat/send
```

### WebSocket Events
```
ws://YOUR_IP:3000/ws

Events:
- connect
- new_message
- message_read
- user_online/offline
- typing/stop_typing
```

## 🔍 Testing Tools

### Built-in Network Tools

Access via **Settings → Network & Development**:

1. **Test Connection** - Verify API connectivity
2. **Find Server** - Auto-discover server on network
3. **Network Config** - View current settings
4. **Test Notification** - Test local notifications

### Manual Testing

**Test API:**
```bash
curl -X GET http://YOUR_IP:3000/api/v1/health
```

**Test WebSocket:**
```javascript
const ws = new WebSocket('ws://YOUR_IP:3000/ws');
ws.onopen = () => console.log('Connected');
```

## 🚀 Deployment

### Development
```bash
flutter run -d windows  # Windows
flutter run -d macos    # macOS  
flutter run -d linux    # Linux
```

### Production Build
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

### Network Security

For local LAN deployment:
- Use HTTP (not HTTPS) for simplicity
- Ensure server accepts connections from LAN IPs
- Configure firewall to allow app traffic
- Consider basic authentication for security

## 📞 Support

If you encounter issues:

1. **Check server logs** for connection attempts
2. **Use network debugging tools** in the app
3. **Verify network connectivity** between devices
4. **Test with different devices** on same network

---

**Note:** This setup is designed for local LAN use. For internet deployment, you'll need HTTPS, proper security, and potentially Firebase for push notifications.