import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/constants/app_constants.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _googleReady = false;
  Stream<User?> authStateChanges() => _auth.authStateChanges();
  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);
  Future<UserCredential> createUserWithEmail(
    String email,
    String password,
    String name,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(name);
    return cred;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (!_googleReady) {
        await GoogleSignIn.instance.initialize(
          serverClientId: AppConstants.googleWebClientId.isNotEmpty
              ? AppConstants.googleWebClientId
              : null,
        );
        _googleReady = true;
      }
      final account = await GoogleSignIn.instance.authenticate();

      final auth = account.authentication;
      if (auth.idToken == null) {
        throw Exception('Google Sign-In failed: ID Token is null. Please verify your Web Client ID and SHA-1 settings.');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      final errString = e.toString().toLowerCase();
      if (errString.contains('canceled') ||
          errString.contains('cancelled') ||
          errString.contains('12501')) {
        return null; // Return null on user cancel without throwing an error
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (_googleReady) await GoogleSignIn.instance.signOut();
  }
}
