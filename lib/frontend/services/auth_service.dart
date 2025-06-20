import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final _auth = fb.FirebaseAuth.instance;

  /// Подписка на смену состояния
  static Stream<fb.User?> authStateChanges() => _auth.authStateChanges();

  /// Email / password
  static Future<fb.User?> signInWithEmail(
      String email, String password) =>
      _auth.signInWithEmailAndPassword(
          email: email, password: password).then((c) => c.user);

  static Future<fb.User?> registerWithEmail(
      String email, String password) =>
      _auth.createUserWithEmailAndPassword(
          email: email, password: password).then((c) => c.user);

  /// Google
  static Future<fb.User?> signInWithGoogle() async {
    final google = await GoogleSignIn().signIn();
    if (google == null) return null;
    final auth = await google.authentication;
    final cred = fb.GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
    return _auth.signInWithCredential(cred).then((c) => c.user);
  }

  /// Facebook
  static Future<fb.User?> signInWithFacebook() async {
    final res = await FacebookAuth.instance.login();
    if (res.status != LoginStatus.success) return null;
    final cred = fb.FacebookAuthProvider.credential(res.accessToken!.token);
    return _auth.signInWithCredential(cred).then((c) => c.user);
  }

  /// GitHub
  static Future<fb.User?> signInWithGithub() async {
    // Создаём провайдера
    final provider = fb.OAuthProvider('github.com');
    // По желанию добавляем scope
    provider.addScope('read:user');

    // Запускаем flow. Появится веб-view/Custom Tab с гитхаб-логином
    final userCredential = await _auth.signInWithProvider(provider);
    return userCredential.user;
  }

  /// Logout
  static Future<void> signOut() => _auth.signOut();
}
