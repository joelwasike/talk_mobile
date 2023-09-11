
class Userr {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const Userr(
      {required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.followers,
      required this.following});

  static Userr fromSnap(snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Userr(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
}
