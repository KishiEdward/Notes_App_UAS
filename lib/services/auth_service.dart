import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:notesapp/services/fcm_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final FCMService _fcmService = FCMService();

  // =========================
  // SIGN IN WITH GOOGLE
  // =========================
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger Google sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancel login
        return null;
      }

      // 🔴 FIX UTAMA: authentication adalah Future
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential oauthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential credential = await _auth.signInWithCredential(
        oauthCredential,
      );

      if (credential.user != null) {
        await _fcmService.saveTokenToFirestore(credential.user!.uid);
      }

      return credential;
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      rethrow;
    }
  }

  // =========================
  // CHECK GOOGLE SIGN-IN
  // =========================
  Future<bool> isGoogleSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  // =========================
  // SILENT GOOGLE SIGN-IN
  // =========================
  Future<UserCredential?> silentGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signInSilently();

      if (googleUser == null) {
        return null;
      }

      // 🔴 FIX UTAMA DI SINI JUGA
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        await _fcmService.saveTokenToFirestore(userCredential.user!.uid);
      }

      return userCredential;
    } catch (e) {
      debugPrint("Silent sign in failed: $e");
      return null;
    }
  }

  // =========================
  // REGISTER EMAIL & PASSWORD
  // =========================
  Future<UserCredential?> registerWithEmail(
    String email,
    String password,
  ) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        await _fcmService.saveTokenToFirestore(credential.user!.uid);
      }

      return credential;
    } catch (e) {
      debugPrint("Error registering with email: $e");
      rethrow;
    }
  }

  // =========================
  // SIGN IN EMAIL & PASSWORD
  // =========================
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _fcmService.saveTokenToFirestore(credential.user!.uid);
      }

      return credential.user;
    } catch (e) {
      debugPrint("Error signing in with email: $e");
      rethrow;
    }
  }

  // =========================
  // SIGN OUT
  // =========================
  Future<void> signOut() async {
    try {
      await _fcmService.deleteToken();
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }

  // =========================
  // RESET PASSWORD
  // =========================
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Email tidak boleh kosong");
    }

    await _auth.sendPasswordResetEmail(email: email);
  }
}
