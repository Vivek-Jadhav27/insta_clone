class UserModel {
  final String uid;
  final String username;
  final String fullname;
  final String email;
  final String profileImageUrl;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final List<dynamic> followersList;
  final List<dynamic> followingList;
  final List<dynamic> postsList;

  UserModel({
    required this.uid,
    required this.username,
    required this.fullname,
    required this.email,
    required this.profileImageUrl,
    required this.bio,
    this.followers = 0,
    this.following = 0,
    this.posts = 0,
    this.followersList = const [],
    this.followingList = const [],
    this.postsList = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'fullname': fullname,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'followers': followers,
      'following': following,
      'posts': posts,
      'followersList': followersList,
      'followingList': followingList,
      'postsList': postsList,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      bio: json['bio'] ?? '',
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      posts: json['posts'] ?? 0,
      followersList: json['followersList'] ?? [],
      followingList: json['followingList'] ?? [],
      postsList: json['postsList'] ?? [],
    );
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? fullname,
    String? email,
    String? profileImageUrl,
    String? bio,
    int? followers,
    int? following,
    int? posts,
    List<dynamic>? followersList,
    List<dynamic>? followingList,
    List<dynamic>? postsList,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      followersList: followersList ?? this.followersList,
      followingList: followingList ?? this.followingList,
      postsList: postsList ?? this.postsList,
    );
  }
}
