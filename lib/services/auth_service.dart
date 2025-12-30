import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:notesapp/services/fcm_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FCMService _fcmService = FCMService();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;


      final OAuthCredential oauthCred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final credential = await _auth.signInWithCredential(oauthCred);
      
      if (credential.user != null) {
        await _fcmService.saveTokenToFirestore(credential.user!.uid);
      }
      
      return credential;
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      rethrow; // Rethrow to let UI handle the error message
    }
  }

  Future<bool> isGoogleSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<UserCredential?> silentGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("Silent sign in failed: $e");
      return null;
    }
  }

  // Register with Email and Password
  Future<UserCredential?> registerWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      debugPrint("Error registering with email: $e");
      rethrow;
    }
  }

  // Sign in with Email and Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        await _fcmService.saveTokenToFirestore(credential.user!.uid);
      }
      
      return credential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _fcmService.deleteToken();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Email tidak boleh kosong");
    }
    await _auth.sendPasswordResetEmail(email: email);
  }
}
