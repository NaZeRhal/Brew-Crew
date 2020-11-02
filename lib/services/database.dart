import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_getBrewListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_createUserDataFromSnapshot);
  }

  //brew list from snapshot
  List<Brew> _getBrewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc.data()['name'] ?? '',
        sugars: doc.data()['sugars'] ?? '0',
        strength: doc.data()['strength'] ?? 0,
      );
    }).toList();
  }

  //userdata from snapshot
  UserData _createUserDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserData(
      uid: uid,
      name: documentSnapshot.data()['name'] ?? '',
      sugars: documentSnapshot.data()['sugars'] ?? '0',
      strength: documentSnapshot.data()['strength'] ?? 0,
    );
  }
}
