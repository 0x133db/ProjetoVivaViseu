import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivaviseu/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          // ignore: deprecated_member_use
          autovalidate: _autoValidate,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 300, 15, 15),
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  //onSaved: _formKey.currentState.save();,
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                      validateEmail(_email);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                ),
              ),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                      color: Theme.of(context).accentColor,
                      child: Text('Sign In'),
                      onPressed: () {
                        auth.signInWithEmailAndPassword(
                            email: _email, password: _password);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                        print('User Sign In');
                      }),
                  RaisedButton(
                      color: Theme.of(context).accentColor,
                      child: Text('Sign Up'),
                      onPressed: () {
                        auth.createUserWithEmailAndPassword(
                            email: _email, password: _password);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                        print('User Sign Up');
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}
