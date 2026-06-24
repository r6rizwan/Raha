class AppConstants {
  static const pageSize = 10;
  static const connectTimeoutSeconds = 10;
  static const receiveTimeoutSeconds = 15;

  // Google Sign-In Web Client ID (required for Android)
  // Can be set here or passed via --dart-define=GOOGLE_WEB_CLIENT_ID=your_client_id
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '569303714843-2jalhisp9ukb2j9kc8nav7b577ep74hd.apps.googleusercontent.com',
  );
}
