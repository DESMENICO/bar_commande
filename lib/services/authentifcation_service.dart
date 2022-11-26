import 'package:firebase_auth/firebase_auth.dart';
import 'package:bar_commande/models/user.dart' as Models;
import 'package:flutter/cupertino.dart';



class AuthentificationService{
  final _auth = FirebaseAuth.instance;

  Models.User userFromFirebase(User? user){


     return Models.User(user!.uid);
  }

  Future<Models.User> signinUser(String mail, String password) async {
    UserCredential firebaseResult = await _auth.signInWithEmailAndPassword(email: mail, password: password);
    User? user = firebaseResult.user;
    return userFromFirebase(user);
  }

}
