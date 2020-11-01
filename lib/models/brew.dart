class Brew {
  final String name;
  final String sugars;
  final int strength;

  Brew({this.name, this.sugars, this.strength});

  @override
  String toString() {
    return 'Brew: name -> $name, sugars -> $sugars, strength -> $strength';
  }
}
