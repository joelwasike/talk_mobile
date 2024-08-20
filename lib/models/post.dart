class Post {
  String content;
  String email;
  int id;
  int likes;
  String media;
  String profilePicture;
  int userId;
  String username;

  Post({
    required this.content,
    required this.email,
    required this.id,
    required this.likes,
    required this.media,
    required this.profilePicture,
    required this.userId,
    required this.username,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? 0,
      likes: json['likes'] ?? 0,
      media: json['media'] ?? '',
      profilePicture: json['profilepicture'] ?? '',
      userId: json['userid'] ?? 0,
      username: json['username'] ?? '',
    );
  }
}
