import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/auth/authenticate.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CustomUser customUser = Provider.of<CustomUser>(context);

    //returtn either home or auth
    return customUser == null ? Authenticate() : Home();
  }
}
