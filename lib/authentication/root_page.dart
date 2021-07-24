import 'package:flutter/material.dart';

import '../FoodApp.dart';
import 'login.dart';
import '../admin/admins.dart';
import 'auth.dart';

AuthStatus authStatus = AuthStatus.notSignedIn;

class RootPage extends StatefulWidget {
  RootPage({Key? key, required this.auth, required this.st}) : super(key: key);
  final BaseAuth auth;
  final String st;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
  admin,
}

class _RootPageState extends State<RootPage> {
  initState() {
    super.initState();
     widget.auth.currentUseremail().then((emailid) {
                print("email:$emailid");
              });
    widget.auth.currentUser().then((userId) {
      widget.auth.currentUser().then((email) {
        print(email);
        setState(() {
          if (userId != null) {
            if (email == 'wBOMg2bZo1TMDuHSf4512Gkf9E63') {
             
              authStatus = AuthStatus.admin;
            } else {
              authStatus = AuthStatus.signedIn;
            }
          } else {
            authStatus = AuthStatus.notSignedIn;
          }
        });
      });
    });
  }

  void updateAuthStatus(AuthStatus status) {
    if (status != AuthStatus.notSignedIn) {
      widget.auth.currentUser().then((email) {
        print(email);
        setState(() {
          authStatus = email == 'wBOMg2bZo1TMDuHSf4512Gkf9E63'
              ? AuthStatus.admin
              : AuthStatus.signedIn;
        });
      });
    } else {
      setState(() {
        authStatus = AuthStatus.notSignedIn;
      });
    }
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        {
          return new LoginPage(
            title: ' Login',
            auth: widget.auth,
            type: widget.st,
            onSignIn: () => updateAuthStatus(AuthStatus.signedIn),
          );
        }
      case AuthStatus.admin:
        {
          return new Admin(
              auth: widget.auth,
              onSignOut: () => updateAuthStatus(AuthStatus.notSignedIn));
        }
      case AuthStatus.signedIn:
        {
          return new FoodApp(
            auth: widget.auth,
            onSignOut: () => updateAuthStatus(AuthStatus.notSignedIn),
            index: 0,
          );
        }
    }
  }
}
