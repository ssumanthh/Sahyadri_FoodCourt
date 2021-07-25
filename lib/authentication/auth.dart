import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String?> currentUseremail();
  Future<String?> currentUser();
  Future<String?> getfid();
  Future<List<dynamic>?> getfavFood();
  Future<String> signIn(String email, String password);
  Future<String> createUser(
      String name, String fid, String email, String password);
  Future<String?> addUserFav(String fname, String name, int i);
  Future<String?> deleteUserFav(String fname);
  Future<void> signOut();
  Future<String?> userOrder(String? fid, String fname, int itemCount, int cost);
  Future<List<dynamic>?> getorder(String fid);
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
  Future<String> createUser(
      String name, String fid, String email, String password) async {
    final UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    print(fid);
    await username.doc(user!.uid).set({'username': name, 'facultyid': fid});
    return user.uid;
  }

  @override
  //get current user id
  Future<String?> currentUser() async {
    User? user = await _firebaseAuth.currentUser;
    print(user);
    return user != null ? user.uid : null;
  }

  Future<String?> getfid() async {
    User? user = await _firebaseAuth.currentUser;
    print(user);
    String? fid = '';
    await username.doc(user!.uid).get().then((value) {
      fid = value.get('facultyid');
      print(fid);
    });
    if (fid != '') {
      return fid;
    }
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

  Future<String?> userOrder(
      String? fid, String fname, int itemCount, int price) async {
    User? user = await _firebaseAuth.currentUser;
    print("fid:$fid\nname:$fname\ncount:$itemCount");
    FirebaseFirestore.instance
        .collection('orders')
        .doc(fid) // <-- Document ID
        .set(
            {
              'orders': FieldValue.arrayUnion([
                {'name': fname, 'itemCount': itemCount, 'price': price}
              ])
            },
            SetOptions(
              merge: true,
            )) // <-- Add data
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

  Future<List<dynamic>?> getorder(String fid) async {
    User? user = await _firebaseAuth.currentUser;
    List<dynamic>? u = [];
    print(fid);
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(fid)
        .get()
        .then((task) => {
              print(task),
              if (task.exists)
                {
                  print(task.get('orders')),
                  u = task.get('orders'),
                  print(u),
                  // print(u![0]['name'])
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
