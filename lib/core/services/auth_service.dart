import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithGoogle() async {
    try {
      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AssertionError("GoogleSignInAccount is null");
      }

      // Obtain authentication details from the signed-in Google account
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Use the credential to sign in with Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Ensure the user object is not null
      if (userCredential.user == null) {
        throw AssertionError("UserCredential user is null");
      }

      // Get user details
      String uid = userCredential.user!.uid;
      String? email = userCredential.user!.email;
      String? name = userCredential.user!.displayName;

      // Ensure necessary fields are not null or empty
      if (uid.isEmpty) throw AssertionError("User UID is empty");
      if (email == null || email.isEmpty) throw AssertionError("User email is empty");
      if (name == null || name.isEmpty) throw AssertionError("User name is empty");

      // Save user details to Firestore
      DocumentReference userDoc = _firestore.collection('users').doc(uid);
      await userDoc.set({
        'email': email,
        'name': name,
      }, SetOptions(merge: true));

      print("User signed in with Google: $uid, $email, $name");
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
