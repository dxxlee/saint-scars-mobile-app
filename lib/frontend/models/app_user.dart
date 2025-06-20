import 'package:firebase_auth/firebase_auth.dart' as fb;

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });

  factory AppUser.fromFirebase(fb.User u) => AppUser(
    uid: u.uid,
    email: u.email ?? '',
    displayName: u.displayName,
    photoURL: u.photoURL,
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoURL': photoURL,
  };
}
