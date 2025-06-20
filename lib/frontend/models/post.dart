class Post {
  final String profileImageUrl;
  final String comment;
  final int timestamp;

  Post({
    required this.profileImageUrl,
    required this.comment,
    required this.timestamp,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      // Если имя поля может приходить как 'profileImageUrl' или 'profile_image_url'
      profileImageUrl: (json['profileImageUrl'] ?? json['profile_image_url']) ?? '',
      comment: json['comment'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileImageUrl': profileImageUrl,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}
