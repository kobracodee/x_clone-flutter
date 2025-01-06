import 'package:x_clone/models/user_model.dart';

class CommentModel {
  final int commentId;
  final int tweetId;
  final int commentUserId;
  final String commentContent;
  final String commentDate;
  final UserModel user;

  CommentModel(
      {required this.commentId,
      required this.tweetId,
      required this.commentUserId,
      required this.commentContent,
      required this.commentDate,
      required this.user});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: int.parse(json['comment_id'].toString()),
      tweetId: int.parse(json['tweet_id'].toString()),
      commentUserId: int.parse(json['comment_user_id'].toString()),
      commentContent: json['comment_content'].toString(),
      commentDate: json['comment_created_at'].toString(),
      user: UserModel.fromJson(json['user']),
    );
  }
}
