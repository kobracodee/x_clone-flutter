import 'package:x_clone/models/user_model.dart';

class PostModel {
  final int id;
  final int userId;
  final String username;
  final String content;
  final DateTime timestamps;
  int likeCount;
  int commentCount;
  List<int> likedby;
  final UserModel user;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.timestamps,
    required this.likeCount,
    required this.commentCount,
    required this.likedby,
    required this.user,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: int.parse(json['id'].toString()), // Parsing post_id
      userId: int.parse(
          json['user']['user_id'].toString()), // Parsing user_id again
      username: json['user']['username'], // Nested user field for username
      content: json['content'], // Content directly
      timestamps: DateTime.parse(
          json['created_at']), // Parsing timestamp string to DateTime
      likeCount: int.parse(json['likes'].toString()), // Parsing likes count
      commentCount:
          int.parse(json['comment_count'].toString()), // Parsing comments count
      likedby: [], // Assuming `likedby` is empty for now or needs to be parsed separately if available in the response
      user: UserModel.fromJson(json['user']), // Nested user model
    );
  }

  // to string
  @override
  String toString() {
    return 'PostModel{userId: $userId, username: $username, content: $content, timestamps: $timestamps, likeCount: $likeCount, likedby: $likedby, user: $user}';
  }
}
