import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//create CustomUser object based on FirebaseUser
  CustomUser _createCustomUser(User firebaseUser) {
    return firebaseUser != null ? CustomUser(uid: firebaseUser.uid) : null;
  }

//auth change user stream
//как раз как роисходит signin или signout запускается этот метод
//и в стриме передает юзера или null
  Stream<CustomUser> get getUserStream {
    return _firebaseAuth.authStateChanges().map(_createCustomUser);
  }

//sign in anonim
  Future signInAnonim() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      User anonUser = userCredential.user;
      return _createCustomUser(anonUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign in in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      // await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);

      return _createCustomUser(user);
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

//register with email and passeord
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      //create a new doc for the user with the uid
      await DatabaseService(uid: user.uid)
          .updateUserData('0', 'new crew member', 100);

      return _createCustomUser(user);
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

//sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
