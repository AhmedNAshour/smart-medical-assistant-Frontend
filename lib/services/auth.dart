import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatbot/models/user.dart';
import 'package:chatbot/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object from Firebase User
  AuthUser _userFromFirbaseUser(User user) {
    return user != null ? AuthUser(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream
  Stream<AuthUser> get user {
    return _auth.authStateChanges().map(_userFromFirbaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return _userFromFirbaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPasword({
    String email,
    String password,
    String fName,
    String lName,
    String gender,
    int age,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      // create new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
        fName: fName,
        lName: lName,
        email: email,
        password: password,
        gender: gender,
        age: age,
      );
      return _userFromFirbaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
