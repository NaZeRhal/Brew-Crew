import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading_spinner.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();

  //for identifying our form
  final _formKey = GlobalKey<FormState>();

  //for showing LoadingSpinner
  bool isLoading = false;

  //text fields
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingSpinner()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign Up to Brew Crew'),
              actions: [
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      //if valid return null
                      validator: (value) =>
                          value.isEmpty ? 'Enter an email' : null,
                      onChanged: (value) {
                        //when text in field changes assing it to variable
                        setState(() => email = value);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      //if valid return null
                      validator: (value) => value.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      obscureText: true,
                      onChanged: (value) {
                        //when text in field changes assing it to variable
                        setState(() => password = value);
                      },
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.pink[400],
                      onPressed: () async {
                        //validate form using key
                        if (_formKey.currentState.validate()) {
                          setState(() => isLoading = true);
                          dynamic result =
                              await _authService.registerWithEmailAndPassword(
                            email,
                            password,
                          );
                          if (result is! CustomUser) {
                            setState(() {
                              isLoading = false;
                              error =
                                  result.substring(result.lastIndexOf(']') + 1);
                            });
                          }
                          //если не null и юзер успешно зарегистрировался
                          //слушатель StreamProvider<CustomUser> узанает об этом
                          //и передаст это через MyApp во Wrapper который покажет Home()
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
