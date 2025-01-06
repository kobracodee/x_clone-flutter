// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:x_clone/models/comment_model.dart';
import 'package:x_clone/models/crud.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/utilities/constants.dart';

class PostProvider extends ChangeNotifier {
  List<PostModel> _allPosts = [];
  bool _isLoading = false;
  final Map<int, List<int>> _likedUsers = {};
  final Crud _crud = Crud();

  List<PostModel> get allPosts => _allPosts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts(String url) async {
    var response = await _crud.getRequest(url);

    if (response != null &&
        response[Constants.SUCCESS] == 'true' &&
        response['tweets'] != null) {
      _allPosts.clear();
      if (response['tweets'] is List) {
        for (var post in response['tweets']) {
          var p = PostModel.fromJson(post);
          var like = await fetchLikedUsers(p.id);
          p.likedby = like;
          _allPosts.add(p);
        }
      }
    }
    notifyListeners();
  }

  // set loading state
  void setLoading(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  void removePost(PostModel post) {
    _allPosts.remove(post);
    notifyListeners();
  }

  void incrementCommentCountPost(PostModel postModel) {
    var post = _allPosts.firstWhere((p) => p.id == postModel.id);
    post.commentCount++;
    log(post.commentCount.toString());
    notifyListeners();
  }

  void decrementCommentCountPost(int postId) {
    var post = _allPosts.firstWhere((p) => p.id == postId);
    post.commentCount--;
    log(post.commentCount.toString());
    notifyListeners();
  }

  // add a comment to a post
  Future<String> addCommentToPost(
      String url, int postId, int userId, String comment) async {
    if (comment.isEmpty) {
      return "Please enter a comment";
    }
    var response = await _crud.postRequest(
      url,
      {
        Constants.USER_ID: userId,
        Constants.TWEETID: postId,
        Constants.COMMENT_CONTENT: comment,
      },
    );

    return response[Constants.MESSAGE].toString();
  }

  // get comment for a post
  Future<List<CommentModel>> getCommentForPost(String url, int postId) async {
    var response = await _crud.postRequest(
      url,
      {
        Constants.TWEETID: postId,
      },
    );

    List<CommentModel> comments = [];
    if (response[Constants.SUCCESS] == 'true') {
      for (var comment in response['comments']) {
        CommentModel c = CommentModel.fromJson(comment);
        comments.add(c);
      }
    }

    return comments;
  }

  // get liked users of each post
  Future<List<int>> fetchLikedUsers(int postId) async {
    var response = await _crud.postRequest(
      "${Constants.BASE_URL}/${Constants.TWEETS}/get_likes.php",
      {
        Constants.TWEETID: postId,
      },
    );

    List<int> likes = [];
    if (response[Constants.SUCCESS] == 'true') {
      for (var like in response['likes']) {
        int l = int.parse(like['like_user_id'].toString());
        likes.add(l);
      }
      _likedUsers[postId] = likes;
    } else {
      log("Error: Failed to fetch liked users.");
    }

    return likes;
  }

  Future<UserModel> getUserById(int id) async {
    var response = await _crud.postRequest(
      "${Constants.BASE_URL}/${Constants.USERAPI}/get_user.php",
      {
        Constants.USER_ID: id,
      },
    );

    return UserModel.fromJson(response[Constants.USER]);
  }

  // like a post
  Future likePost(int postId, int userId) async {
    var response = await _crud.postRequest(
      "${Constants.BASE_URL}/${Constants.TWEETS}/like_post.php",
      {
        Constants.TWEETID: postId,
        Constants.USER_ID: userId,
      },
    );

    if (response[Constants.SUCCESS] == 'success') {
      return true;
    }
    return false;
  }

  // remove like from a post
  Future removeLike(int postId, int userId) async {
    var response = await _crud.postRequest(
      "${Constants.BASE_URL}/${Constants.TWEETS}/remove_like.php",
      {
        Constants.TWEETID: postId,
        Constants.USER_ID: userId,
      },
    );

    if (response[Constants.SUCCESS] == 'true') {
      return true;
    }
    return false;
  }

  // fetch comments for a post
  Future<List<CommentModel>> fetchComments(int postId) async {
    var response = await _crud.postRequest(
      "${Constants.BASE_URL}/${Constants.TWEETS}/comments_post.php",
      {
        Constants.TWEETID: postId,
      },
    );

    List<CommentModel> comments = [];
    if (response[Constants.SUCCESS] == 'true') {
      for (var comment in response['comments']) {
        CommentModel c = CommentModel.fromJson(comment);
        comments.add(c);
      }
    }

    return comments;
  }

  List<PostModel> filterUserPosts(int id) {
    return _allPosts.where((post) => post.userId == id).toList();
  }

  PostModel getPostById(int id) {
    return _allPosts.firstWhere((post) => post.id == id);
  }

  UserModel getUserByIdFromPosts(int id) {
    return _allPosts.firstWhere((post) => post.userId == id).user;
  }
}
