import 'package:bar_commande/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bar_commande/models/user.dart' as Models;




class AuthentificationService{
  final _auth = FirebaseAuth.instance;

  Models.User userFromFirebase(User? user){
     return Models.User.auth(user!.uid);
  }

  Future<Models.User> signinUser(String mail, String password) async {
    UserCredential firebaseResult = await _auth.signInWithEmailAndPassword(email: mail, password: password);
    User? user = firebaseResult.user;
    return userFromFirebase(user);
  }

<<<<<<< HEAD
  Future<Models.User> 
  createUser(String mail, String password) async {
    UserCredential firebaseResult = await _auth.createUserWithEmailAndPassword(email: mail, password: password);
=======
  Future<Models.User> createUser(String mail, String password) async {
  UserCredential firebaseResult = await _auth.createUserWithEmailAndPassword(email: mail, password: password);
>>>>>>> b0589b38468763ac70229aaff1c05b1aaa55a829
   User? user = firebaseResult.user;
    return userFromFirebase(user);
  } 


}

