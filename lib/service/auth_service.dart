import 'package:booktoplay_app/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null 
      ? AppUser(uid: user.uid, email: user.email ?? 'anonymous') 
      : null;
  }

  Stream<AppUser?> get user => _auth.authStateChanges().map(_userFromFirebaseUser);

  // Register + Firestore Entry
  Future<AppUser?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
    
        return _userFromFirebaseUser(user);
      }
      return null;
    } catch (e) {
      print("Registration Error: $e"); // CHECK YOUR DEBUG CONSOLE FOR THIS MESSAGE
      return null;
    }
}

  // Sign In (No Firestore write needed here)
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print("SignIn Error: $e");
      return null;
    }
  }
}