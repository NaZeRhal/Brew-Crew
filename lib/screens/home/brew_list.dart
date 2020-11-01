import 'package:brew_crew/models/brew.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewList extends StatefulWidget {
  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final List<Brew> brewList = Provider.of<List<Brew>>(context);
    if (brewList != null) {
      brewList.forEach(print);
    }
    return Container();
  }
}
