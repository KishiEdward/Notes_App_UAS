# README - Push Notification Feature

## Overview
NekoMind now supports push notifications using Firebase Cloud Messaging (FCM).

## Features
- ✅ Foreground notifications
- ✅ Background notifications
- ✅ Terminated app notifications
- ✅ Auto token management (save on login, delete on logout)
- ✅ Topic subscription support
- ✅ Notification settings page
- ✅ Comprehensive error handling

## Setup
1. Ensure Firebase is configured
2. Run `flutter pub get`
3. Build and run the app
4. Permissions will be requested automatically

## Testing
Send test notifications from Firebase Console:
1. Go to Cloud Messaging
2. Click "Send your first message"
3. Enter title and body
4. Select your app
5. Send!

## Files Modified
- `lib/services/fcm_service.dart` - Main FCM service
- `lib/utils/fcm_background_handler.dart` - Background handler
- `lib/main.dart` - FCM initialization
- `lib/services/auth_service.dart` - Token management
- `lib/pages/notification_settings_page.dart` - Settings UI
- `android/app/src/main/AndroidManifest.xml` - Permissions

## Total Commits: 50+
