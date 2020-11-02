import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final CustomUser customUser = Provider.of<CustomUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: customUser.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your brew settings',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration,
                    validator: (value) =>
                        value.isEmpty ? 'Please enter a name' : null,
                    onChanged: (value) => setState(() => _currentName = value),
                  ),
                  SizedBox(height: 20),

                  //dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData.sugars,
                    items: sugars
                        .map(
                          (sugar) => DropdownMenuItem(
                            value: sugar,
                            child: Text('$sugar sugars'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _currentSugars = value),
                  ),

                  //sliber
                  Slider(
                    activeColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    min: 100,
                    max: 900,
                    divisions: 8,
                    onChanged: (value) =>
                        setState(() => _currentStrength = value.round()),
                  ),

                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: customUser.uid)
                            .updateUserData(
                                _currentSugars ?? userData.sugars,
                                _currentName ?? userData.name,
                                _currentStrength ?? userData.strength);
                      }
                      //close settings
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          } else {
            return LoadingSpinner();
          }
        });
  }
}
