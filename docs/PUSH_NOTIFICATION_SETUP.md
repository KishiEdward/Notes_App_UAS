# Push Notification Setup Guide

## Firebase Console Setup

1. Buka Firebase Console
2. Pilih project NekoMind
3. Ke Cloud Messaging
4. Send test message

## Testing

### Foreground Test
- Buka app
- Send notification dari Firebase Console
- Notification harus muncul sebagai banner

### Background Test
- Minimize app
- Send notification
- Notification muncul di tray

### Terminated Test
- Close app completely
- Send notification
- Notification tetap muncul
