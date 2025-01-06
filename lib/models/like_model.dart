class LikeModel {
  final int likeId;
  final int tweetId;
  final int tweetUserId;
  final String likeCreatedAt;

  LikeModel({
    required this.likeId,
    required this.tweetId,
    required this.tweetUserId,
    required this.likeCreatedAt,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      likeId: int.parse(json['like_id'].toString()),
      tweetId: int.parse(json['tweet_id'].toString()),
      tweetUserId: int.parse(json['like_user_id'].toString()),
      likeCreatedAt: json['like_created_at'].toString(),
    );
  }
}
