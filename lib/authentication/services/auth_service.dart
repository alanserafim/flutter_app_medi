import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../domain/models/medi_user.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> userSignUp(
      { required String email, required String password, required String name}) async {
    debugPrint('method: AuthService.userSignUp');
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return "Uma conta com este email já existe";
      }
      debugPrint("Firebase error while signinUp a user: '${e.code}'");
      return e.code;
    } catch (e, stack) {
      debugPrint("Unexpected error while signinUp a user: $e");
      debugPrint(stack.toString());
      rethrow;
    }
    return null;
  }


  Future<String?> userSignIn(
      { required String email, required String password}) async {
    debugPrint('method: AuthService.userLogin');
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "usuário ou senha incorreta";
        case "wrong-password":
          return "usuário ou senha incorreta";
        case "invalid-credential":
          return "usuário ou senha incorreta";
      }
      debugPrint("Firebase error while signIn process: '${e.code}'");
      return e.code;
    } catch (e, stack) {
      debugPrint("Unexpected error while signIn process: $e");
      debugPrint(stack.toString());
      rethrow;
    }
    return null;
  }

  Future<String?> redefinePassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "E-mail não cadastrado.";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<String?> removeAccount({required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: _firebaseAuth.currentUser!.email!, password: password);
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<MediUser?> getUserData() async {
    if(await _firebaseAuth.currentUser != null){
      MediUser mediUser = MediUser(
        name: _firebaseAuth.currentUser!.displayName!,
        email: _firebaseAuth.currentUser!.email!,
        photoUrl: _firebaseAuth.currentUser!.photoURL!,
      );
      return mediUser;
    }
    return null;
  }

  //update name
  Future<String?> updateName(String name) async {
    try {
      await _firebaseAuth.currentUser!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }




}
