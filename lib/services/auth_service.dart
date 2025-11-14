import 'package:firebase_auth/firebase_auth.dart';
import 'auth_prefs.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await AuthPrefs.saveLogin(email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login error';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await AuthPrefs.saveLogin(email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Register error';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {}
    await AuthPrefs.clear();
  }
}
