import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/constants/app_constants.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

String authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Your password is too weak. Please use a stronger password.';
      case 'too-many-requests':
        return 'Too many attempts right now. Please try again later.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'operation-not-allowed':
        return 'This sign-in method is not available right now.';
    }
  }

  final text = error.toString().toLowerCase();
  if (text.contains('clientconfigurationerror') ||
      text.contains('web client id') ||
      text.contains('sha-1') ||
      text.contains('sha1') ||
      text.contains('id token is null')) {
    return 'Google sign-in is not configured correctly for this app build yet.';
  }
  if (text.contains('network') || text.contains('socket')) {
    return 'Check your internet connection and try again.';
  }
  if (text.contains('too-many-requests')) {
    return 'Too many attempts right now. Please try again later.';
  }
  return 'We could not sign you in right now. Please try again.';
}

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
        throw Exception(
          'Google sign-in is not configured correctly for this app build yet.',
        );
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
