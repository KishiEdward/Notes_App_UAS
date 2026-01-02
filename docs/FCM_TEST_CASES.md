# FCM Service Test Cases

## Test 1: Token Generation
- Initialize FCM
- Get token
- Verify token is not null

## Test 2: Save Token
- Login with email
- Verify token saved to Firestore
- Check users collection

## Test 3: Delete Token
- Logout
- Verify token deleted
- Check Firestore

## Test 4: Foreground Notification
- App open
- Send test notification from Firebase Console
- Verify notification appears

## Test 5: Background Notification
- App minimized
- Send notification
- Verify appears in tray

## Test 6: Terminated Notification
- App closed
- Send notification
- Verify still works
