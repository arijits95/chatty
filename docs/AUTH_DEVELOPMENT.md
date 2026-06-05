# Auth Development

Chatty keeps authentication behind app-owned repositories and use cases so development can continue without production Apple Push Notification service setup.

## Development Strategy

- Use the `development` environment for Firebase-backed local work.
- Use the `demo` environment for Firebase-free previews, tests, and screenshots.
- Add a `DemoAuthRepository` when implementing auth contracts so previews, tests, and screenshots can run without Firebase.
- Use Firebase only inside Data/Infrastructure implementations.
- Keep Domain and Presentation free of Firebase SDK imports.

## Firebase Phone Auth Testing

Use Firebase Authentication test phone numbers during development:

1. Open Firebase Console.
2. Go to Authentication -> Sign-in method.
3. Enable Phone.
4. Add test phone numbers and fixed OTP codes.
5. Use those test numbers in the app while building the flow.

Test numbers avoid real SMS delivery and are the default path for local development.

## APNs Limitation

Firebase Phone Auth on iOS can use silent APNs notifications for app verification. Production APNs credentials require a paid Apple Developer account.

Until that is available:

- rely on Firebase test phone numbers,
- support Firebase's reCAPTCHA fallback,
- keep local/demo auth independent through `DemoAuthRepository`,
- defer production push-notification verification to a later ticket.

## Production Follow-up

When an Apple Developer account is available, add APNs credentials in Firebase and validate:

- silent push verification for Firebase Phone Auth,
- FCM token registration,
- message push notification delivery,
- notification deep linking into a chat.
