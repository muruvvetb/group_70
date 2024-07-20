import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google Sign In Method
  signInWithGoogle() async {
    // Begin interactive sign-in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      return null; // User canceled the sign-in process
    }

    // Obtain auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
