import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String?> currentUseremail();
  Future<String?> currentUser();
  Future<List<dynamic>?> getfavFood();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String name, String email, String password);
  Future<String?> addUserFav(String fname, String name, int i);
  Future<String?> deleteUserFav(String fname);
  Future<void> signOut();
  Future<String?> userOrder(String fname,  int itemCount);
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
  Future<String?> addUserFav(String fname, String name, int i) async {
    User? user = await _firebaseAuth.currentUser;
    username
        .doc(user!.uid) // <-- Document ID
        .set({
          'favFood': FieldValue.arrayUnion([fname])
        }, SetOptions(merge: true)) // <-- Add data
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
    return user != null ? user.email : null;
  }
Future<String?> userOrder(String fname,  int itemCount) async {
    User? user = await _firebaseAuth.currentUser;
    username
        .doc(user!.uid) // <-- Document ID
        .set({
          'Orders':{
            'name': fname,
            'itemCount': itemCount
          }
        }, SetOptions(merge: true)) // <-- Add data
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
    return user != null ? user.email : null;
  }
  Future<String?> deleteUserFav(String fname) async {
    User? user = await _firebaseAuth.currentUser;
    username
        .doc(user!.uid) // <-- Document ID
        .update({
   'favFood': FieldValue.arrayRemove([fname])
}) // <-- Delete data
        .then((_) => print('deletd'))
        .catchError((error) => print('Add failed: $error'));
    return user != null ? user.email : null;
  }

  Future<List<dynamic>?> getfavFood() async {
    User? user = await _firebaseAuth.currentUser;
    List<dynamic>? u = [];
    bool l = true;
    await username.doc(user!.uid).get().then((task) => {
          if (task.exists)
            {
              l = false,
              u = task.get('favFood'),
            }
        });

    return u;
  }

//sinout method
  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
