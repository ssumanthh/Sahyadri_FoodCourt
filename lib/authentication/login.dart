// import 'dart:async';

import 'package:flutter/material.dart';
import 'auth.dart';
import '../widgets/loader.dart';
import '../widgets/primary_button.dart';

bool googleSignIn = false;

class LoginPage extends StatefulWidget {
  LoginPage(
      {Key? key,
      required this.title,
      required this.auth,
      required this.onSignIn,
      required this.type})
      : super(key: key);
  final String type;
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

//values to check user want to signin or register
enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();
  static bool a = true;
  String? _name;
  String? _email;
  String? _password;
  bool loading = false;

  FormType _formType = FormType.login;
  String _authHint = '';

  bool validateAndSave() {
    //form validation
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    //validate the details entered
    if (validateAndSave()) {
      setState(() {
        loading = true;
      });
      //if user enters admin id then give error msg
      if (_email != 'foodcour@gmail.com') {
        
        try {
          String userId = _formType == FormType.login
              ? await widget.auth.signIn(_email!, _password!)
              : await widget.auth.createUser(_name!, _email!, _password!);
          setState(() {
            _authHint = 'Signed In\n\nUser id: $userId';
          });
          print("done sigin");
          widget.onSignIn();
        } catch (e) {
          setState(() {
            loading = false;
            _authHint = e.toString();
          });
          String msg;
          _formType == FormType.login
              ? msg = 'Login Failed'
              : msg = 'Registration Failed';
          print(e);
        }
      } else {
        loading = false;
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void validateAndCheck() async {
    //login as admin only
    if (validateAndSave()) {
      setState(() {
        loading = true;
      });
      if (_email == 'foodcourt@gmail.com') {
        try {
          String userId = await widget.auth.signIn(_email!, _password!);
          setState(() {
            _authHint = 'Signed In\n\nUser id: $userId';
          });
          print("done sigin");
          widget.onSignIn();
        } catch (e) {
          setState(() {
            loading = false;
            _authHint = e.toString();
          });

          print(e);
        }
      } else {
        loading = false;
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }
  //change the form in the page to register page
  void moveToRegister() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }
//change the form in the page to login page
  void moveToLogin() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }
//text field change
  List<Widget> usernameAndPassword() {
    if (a == true) {
      if (widget.type == 'Register') {
        setState(() {
          _formType = FormType.register;
          _authHint = '';
        });
      } else {
        setState(() {
          _formType = FormType.login;
          _authHint = '';
        });
      }
      a = false;
    }
 
  //for login page style of text field and the display text
    if (_formType == FormType.login) {
      return [
        SizedBox(height: 150),
        new Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: new SafeArea(
                child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: new Row(
                  children: [
                    Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFFf68634),
                      ),
                    ),
                    Text(
                      ' to your account',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                  child: new TextFormField(
                    key: new Key('email'),
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email Here...',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFFf68634),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: Color(0xFFf68634), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Color(0xFFf68634), width: 1),
                      ),
                    ),
                    autocorrect: false,
                    validator: (val) =>
                        val!.isEmpty ? 'Email can\'t be empty.' : null,
                    onSaved: (val) => _email = val,
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: new TextFormField(
                  key: new Key('password'),
                  decoration: InputDecoration(
                    hintText: 'Enter Your password Here...',
                    prefixIcon: Icon(
                      Icons.enhanced_encryption,
                      color: Color(0xFFf68634),
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFf68634), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFf68634), width: 1),
                    ),
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: (val) =>
                      val!.isEmpty ? 'Password can\'t be empty.' : null,
                  onSaved: (val) => _password = val,
                ),
              ),
            ])))
      ];
    } else {
      //for register page style of text field and the display text
      return [
        SizedBox(height: 150),
        new Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: new SafeArea(
                child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: new Row(
                  children: [
                    Text(
                      'Create',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFFf68634),
                      ),
                    ),
                    Text(
                      ' your account',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: new TextFormField(
                  key: new Key('name'),
                  decoration: InputDecoration(
                    hintText: 'Enter Your name Here...',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFFf68634),
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFf68634), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFf68634), width: 1),
                    ),
                  ),
                  autocorrect: false,
                  validator: (val) => val!.isEmpty
                      ? 'Username can\'t be empty.'
                      : val.length < 2
                          ? 'user name must be at least 2 charecter long'
                          : null,
                  onSaved: (val) => _name = val,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                child: new TextFormField(
                  key: new Key('email'),
                  decoration: InputDecoration(
                    hintText: 'Enter Your Email Here...',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFFf68634),
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFf68634), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFf68634), width: 1),
                    ),
                  ),
                  autocorrect: false,
                  validator: (val) =>
                      val!.isEmpty ? 'Email can\'t be empty.' : null,
                  onSaved: (val) => _email = val,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: new TextFormField(
                  key: new Key('password'),
                  decoration: InputDecoration(
                    hintText: 'Enter Your password Here...',
                    prefixIcon: Icon(
                      Icons.enhanced_encryption,
                      color: Color(0xFFf68634),
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFf68634), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFf68634), width: 1),
                    ),
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: (val) =>
                      val!.isEmpty ? 'Password can\'t be empty.' : null,
                  onSaved: (val) => _password = val,
                ),
              ),
            ])))
      ];
    }
  }

//submit button style
  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          SizedBox(height: 20),
          new PrimaryButton(
              key: new Key('login'),
              text: 'Login as User',
              height: 50.0,
              onPressed: validateAndSubmit),
          SizedBox(height: 5),
          new PrimaryButton(
              key: new Key('AdminLogin'),
              text: 'Login as Admin',
              height: 50.0,
              onPressed: validateAndCheck),
          SizedBox(height: 5),
          new Text(
            'OR',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 5),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            new FlatButton(
                key: new Key('need-account'),
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text(
                        "don't have an account?",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      new Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ]),
                onPressed: moveToRegister),
          ]),
        ];
      case FormType.register:
        return [
          SizedBox(height: 20),
          new PrimaryButton(
              key: new Key('register'),
              text: 'Create an account',
              height: 50.0,
              onPressed: validateAndSubmit),
          SizedBox(height: 5),
          new Text(
            'OR',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 5),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            new FlatButton(
                key: new Key('need-login'),
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text("Have an account? ",
                          style: TextStyle(
                            color: Colors.black54,
                          )),
                      new Text("Login",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold))
                    ]),
                onPressed: moveToLogin)
          ]),
        ];
    }
  }

  Widget hintText() {
    return new Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(_authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return loading == true
        ? Loader()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              height: _height,
              width: _width,
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: usernameAndPassword() + submitWidgets(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
