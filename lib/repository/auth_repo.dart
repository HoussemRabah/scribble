import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  FirebaseAuth authDb = FirebaseAuth.instance;

  Future<UserCredential> signIn() async {
    UserCredential user = await authDb.signInAnonymously();
    await Future.delayed(Duration(milliseconds: 2000));

    return user;
  }
}
