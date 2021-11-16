import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

String name;
String email;
String imageUrl;
String provider;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      // Store the retrieved data
      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;
      provider = currentUser.providerData[0].providerId;

      // Only taking the first part of the name, i.e., First Name
      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }
  }

  return null;
}

Future<void> signUp(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print("berhasil! SignUp");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
  // try {
  //   UserCredential result = await _auth.createUserWithEmailAndPassword(
  //       email: email, password: password);
  //   print(result);
  //   print("cek");
  //   // FirebaseUser user = result.user;

  // } catch (e) {
  //   switch (e.code) {
  //     case 'email-already-in-use':
  //       print("error gaes");
  //   }
  // }
  // return Future.value(true);
}

Future<String> signIn(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
  // try {
  //   UserCredential result = await _auth.signInWithEmailAndPassword(
  //       email: email, password: password);
  //   // FirebaseUser user = result.user;
  //   return Future.value(true);
  // } catch (e) {
  //   switch (e.code) {
  //     case 'email-already-in-use':
  //       print("error gaes");
  //   }
  // }
}

Future<void> signOutGoogle(String provider) async {
  if (provider == 'google.com') {
    googleSignIn.signOut();
    print("google Logout");
  }

  await _auth.signOut();
  // await FirebaseAuth.instance.signOut();

  print("User Signed Out");
}
