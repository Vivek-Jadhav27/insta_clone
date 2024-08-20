class PostModel {
  final String id;
  final String userId;
  final String username;
  final String userProfileImageUrl;
  final String caption;
  final String createAt;
  final List<dynamic> imageUrls;
  final List<dynamic> likeslist;
  final List<dynamic> commentslist;
  final List<dynamic> mentionlist;
  final int likes;
  final int comments;
  final int shares;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.caption,
    required this.imageUrls,
    required this.createAt,
    required this.userProfileImageUrl,
    this.likeslist = const [],
    this.commentslist = const [],
    this.mentionlist = const [],
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userProfileImageUrl': userProfileImageUrl,
      'caption': caption,
      'createAt': createAt,
      'imageUrls': imageUrls,
      'likeslist': likeslist,
      'commentslist': commentslist,
      'mentionlist': mentionlist,
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
      userProfileImageUrl: json['userProfileImageUrl'] ?? '',
      caption: json['caption'] ?? '',
      imageUrls: json['imageUrls'] ?? [],
      createAt: json['createAt'] ?? '',
      likeslist: json['likeslist'] ?? [],
      commentslist: json['commentslist'] ?? [],
      mentionlist: json['mentionlist'] ?? [],
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
    );
  }
}
