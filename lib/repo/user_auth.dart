import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential;
      }
      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  /// Sign in with Facebook
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential = FacebookAuthProvider.credential(
          accessToken.token,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential;
      }
      return null;
    } catch (e) {
      print('Error signing in with Facebook: $e');
      return null;
    }
  }

  /// Sign in with phone number
  Future<void> signInWithPhoneNumber(String phoneNumber, Function(String) codeSentCallback, Function(FirebaseAuthException) errorCallback) async {
    try {
      // Configure the verification process
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically verify and sign-in the user (if possible)
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          errorCallback(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Provide the verification ID to the callback
          codeSentCallback(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle auto retrieval timeout (optional)
        },
      );
    } catch (e) {
      print('Error signing in with phone number: $e');
      errorCallback(e as FirebaseAuthException);
    }
  }

  String? getCurrentUserId() {
    User? currentUser = _auth.currentUser;
    return currentUser?.uid;
  }

  /// Sign out the user
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _facebookAuth.logOut();
  }
}
