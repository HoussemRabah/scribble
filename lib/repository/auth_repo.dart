import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  FirebaseAuth authDb = FirebaseAuth.instance;

  Future<UserCredential> signIn() async {
    UserCredential user = await authDb.signInAnonymously();
    return user;
  }
}
