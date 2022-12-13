

import 'package:firebase_auth/firebase_auth.dart';
import 'package:bar_commande/models/user.dart' as models;




class AuthentificationService{
  final _auth = FirebaseAuth.instance;

  models.User userFromFirebase(User? user){
     return models.User.auth(user!.uid);
  }

  Future<models.User> signinUser(String mail, String password) async {
    UserCredential firebaseResult = await _auth.signInWithEmailAndPassword(email: mail, password: password);
    User? user = firebaseResult.user;
    return userFromFirebase(user);
  }

  Future<void> removeUser(models.User user) async{
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: user.email, password: user.password);
    User? userToDelete  = userCredential.user;
    userToDelete!.delete();
  }

  Future<models.User> updateUser(models.User user) async{
    removeUser(user);
    return createUser(user.email, user.password);
  }



  Future<models.User> createUser(String mail, String password) async {
  UserCredential firebaseResult = await _auth.createUserWithEmailAndPassword(email: mail, password: password);
   User? user = firebaseResult.user;
    return userFromFirebase(user);
  } 


}

