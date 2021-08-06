import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String?> currentUseremail();
  Future<String?> currentUser();
  Future<String?> getfid();
  Future<String?> getname();
  Future<List<dynamic>?> getfavFood();
  Future<String?> signIn(String email, String password);
  Future<String?> createUser(
      String name, String fid, String email, String password);
  Future<String?> addUserFav(String fname);
  Future<String?> deleteUserFav(String fname);
  Future<void> signOut();
  Future<String?> userOrder(String? fid, String fname, int itemCount, int cost);
  Future<List<dynamic>?> getorder(String fid);
  Future<bool> verifEmail();
  Future<void> resetPassword(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference username =
      FirebaseFirestore.instance.collection('name');

  //signIn method
  Future<String?> signIn(String email, String password) async {
    final User? user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    return user!.uid=='wBOMg2bZo1TMDuHSf4512Gkf9E63'?user.uid:user.emailVerified ? user.uid : null;
  }

  Future<bool> verifEmail() async {
    User? user = await _firebaseAuth.currentUser;
    bool? d;
    await user!.sendEmailVerification().then((value) => d = true);
    return d!;
  }

//Register user details
  Future<String?> createUser(
      String name, String fid, String email, String password) async {
    final UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    print(fid);
    await username.doc(user!.uid).set({
      'username': name,
      'facultyid': fid,
      'favFood': [],
    });

    await user.sendEmailVerification();
    return user.emailVerified ? user.uid : null;
  }

  @override
  //get current user id
  Future<String?> currentUser() async {
    User? user = await _firebaseAuth.currentUser;
    print(user);
    return user != null
        ?user.uid=='wBOMg2bZo1TMDuHSf4512Gkf9E63'?user.uid: user.emailVerified
            ? user.uid
            : null
        : null;
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
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

  Future<String?> getname() async {
    User? user = await _firebaseAuth.currentUser;
    print(user);
    String? fid = '';
    await username.doc(user!.uid).get().then((value) {
      fid = value.get('username');
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
  Future<String?> addUserFav(String fname) async {
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
                {'name': fname, 'itemCount': itemCount, 'price': price,'status':'waiting'}
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
