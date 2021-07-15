import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String?> currentUseremail();
  Future<String?> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String name, String email, String password);
  Future<String?> addUserFav(String fname, String link, String price);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference username =
      FirebaseFirestore.instance.collection('name');

      //signIn method
  Future<String> signIn(String email, String password) async {
    final User? user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    return user!.uid;
  }

//Register user details
  Future<String> createUser(String name, String email, String password) async {
    final UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    await username.doc(user!.uid).set({'username': name});
    return user.uid;
  }

  @override
  //get current user id
  Future<String?> currentUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

//get current user mail address
  Future<String?> currentUseremail() async {
    User? user = await _firebaseAuth.currentUser;
    return user != null ? user.email : null;
  }

//add user's fav food to database
   Future<String?> addUserFav(String fname,String link, String price) async {
    User? user = await _firebaseAuth.currentUser;
    await username.doc(user!.uid).set({'FavFood': {'name':fname,'link':link,'price':price}},SetOptions(merge : true));
    return user != null ? user.email : null;
  }

//sinout method
  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
