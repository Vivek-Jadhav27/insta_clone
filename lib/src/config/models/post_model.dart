class PostModel {
  final String id;
  final String userId;
  final String username;
  final String caption;
  final String timestamp;
  final List<dynamic> imageUrls;
  final List<dynamic> likeslist;
  final List<dynamic> commentslist;
  final int likes;
  final int comments;
  final int shares;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.caption,
    required this.imageUrls,
    required this.timestamp,
    this.likeslist = const [],
    this.commentslist = const [],
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'caption': caption,
      'timestamp': timestamp,
      'imageUrls': imageUrls,
      'likeslist': likeslist,
      'commentslist': commentslist,
      'likes': likes,
      'comments': comments,
      'shares': shares,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      caption: json['caption'] ?? '',
      imageUrls: json['imageUrls'] ?? [],
      timestamp: json['timestamp'] ?? '',
      likeslist: json['likeslist'] ?? [],
      commentslist: json['commentslist'] ?? [],
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
    );
  }
}
