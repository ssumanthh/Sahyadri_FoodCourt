// import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  String? _fid;
  String? _email;
  String? _password;
  bool loading = false;
  bool showPassword = false;

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
      try {
        String? userId = '';
        if (_formType == FormType.login) {
          userId = await widget.auth.signIn(_email!, _password!);
        } else {
          userId =
              await widget.auth.createUser(_name!, _fid!, _email!, _password!);
          setState(() {
            _formType = FormType.login;
            showPassword = false;
            loading = false;
          });
          
          Alert(
                  context: context,
                  title: "Verify your Email Address ",
                  desc: "Mail has been sent to the registered email id")
              .show();
        }
        print("$userId");
        if (userId != null) {
          widget.onSignIn();
        } else {
          setState(() {
            loading = false;
            showPassword = false;
            _formType = FormType.login;
          });
          Alert(
                  context: context,
                  title: "Verify your Email Address ",
                  desc: "Please verify your email id")
              .show();
        }
      } catch (e) {
        setState(() {
          loading = false;
          _authHint = e.toString();
          _authHint.contains('[firebase_auth/network-request-failed]')
              ? _authHint = 'Check your Internet Connection!!'
              : _authHint = 'Invalid userName or Password!!';
        });
        String msg;
        _formType == FormType.login
            ? msg = 'Login Failed'
            : msg = 'Registration Failed';
        Alert(context: context, title: msg, desc: _authHint).show();
        print(e);
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
      showPassword = false;
      _authHint = '';
    });
  }

//change the form in the page to login page
  void moveToLogin() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.login;
      showPassword = false;
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
        SizedBox(
          height: 50,
          child: Image(
            image: AssetImage('assets/images/sahyadrilogo.jpg'),
          ),
        ),
        new Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(21)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: new SingleChildScrollView(
                child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(19.0, 20.0, 20.0, 10.0),
                child: new Row(
                  children: [
                    AutoSizeText(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFFf68634),
                      ),
                    ),
                    AutoSizeText(
                      ' to your account',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new TextFormField(
                      key: new Key('password'),
                      decoration: InputDecoration(
                        hintText: 'Enter Your password Here...',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
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
                      obscureText: !showPassword,
                      autocorrect: false,
                      validator: (val) =>
                          val!.isEmpty ? 'Password can\'t be empty.' : null,
                      onSaved: (val) => _password = val,
                    ),
                    TextButton(
                        onPressed: () {
                          TextEditingController text =
                              new TextEditingController();
                          Alert(
                                  buttons: [
                                DialogButton(
                                    child: Text("submit"),
                                    onPressed: () {
                                      if (text.text.isNotEmpty) {
                                        print("true");
                                        widget.auth.resetPassword(text.text);
                                      }
                                    }),
                              ],
                                  content: TextField(
                                    controller: text,
                                    decoration: InputDecoration(
                                        hintText: "Enter email id"),
                                  ),
                                  context: context,
                                  title: "Reset Password ",
                                  desc:
                                      "Please Enter email address to send link")
                              .show();
                        },
                        child: Text(
                          "Forget password?",
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              ),
              // TextButton(
              //     onPressed: () async{
              //      bool check= await widget.auth.verifEmail();
              //      if(check){
              //         final snackBar = SnackBar(
              //                     backgroundColor: Color(0xFFf68634),
              //                     padding: EdgeInsets.all(15),
              //                     content:
              //                         Text('Email sent succussfully',
              //                             style: TextStyle(
              //                               color: Colors.white,
              //                             )));
              //                 ScaffoldMessenger.of(context)
              //                     .showSnackBar(snackBar);
              //      }
              //     }, child: Text("Resend Email Verification?"))
            ])))
      ];
    } else {
      //for register page style of text field and the display text
      return [
        SizedBox(
            height: 50,
            child: Image(
              image: AssetImage('assets/images/sahyadrilogo.jpg'),
            )),
        new Container(
            height: 340,
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
                  offset: Offset(0, 0.5), // changes position of shadow
                ),
              ],
            ),
            child: new SingleChildScrollView(
                child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                child: new Row(
                  children: [
                    SizedBox(height: 10),
                    AutoSizeText(
                      'Create',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFFf68634),
                      ),
                    ),
                    AutoSizeText(
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
                      : val.length < 4
                          ? 'user name must be at least 4 charecter long'
                          : null,
                  onSaved: (val) => _name = val,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: new TextFormField(
                  key: new Key('fid'),
                  decoration: InputDecoration(
                    hintText: 'Enter Your Faculty ID...',
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
                      ? 'Faculty Id can\'t be empty.'
                      : !(val.contains(
                              RegExp(r"^(FA|fa|NT|nt)([0-9]{4}|[0-9]{3})$")))
                          ? 'Invaild Faculty Id'
                          : null,
                  onSaved: (val) => _fid = val,
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
                  validator: (val) => val!.isEmpty
                      ? 'Email can\'t be empty.'
                      : !(val.contains(RegExp(
                              r"\.(is18|cs|is|ec|aptra)@sahyadri\.edu\.in$")))
                          ? 'Unauthorized user Email'
                          : null,
                  onSaved: (val) => _email = val,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                child: new TextFormField(
                  key: new Key('password'),
                  decoration: InputDecoration(
                    hintText: 'Enter Your password Here...',
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
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
                  obscureText: !showPassword,
                  autocorrect: false,
                  validator: (val) => val!.isEmpty
                      ? 'Password can\'t be empty.'
                      : !(val.contains(RegExp(
                              r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$")))
                          ? 'Password must contain min 8 charecters\n(letters+special symbols+numbers)'
                          : null,
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
              text: 'Login',
              height: 40.0,
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
          Column(children: [
            new FlatButton(
                key: new Key('need-account'),
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: new AutoSizeText(
                          "don't have an account?",
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      new AutoSizeText(
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
              height: 40.0,
              onPressed: validateAndSubmit),
          SizedBox(height: 5),
          new Text(
            'OR',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          Column(children: [
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
        : SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                  height: _height * 0.87,
                  width: _width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
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
                )),
          );
  }
}
