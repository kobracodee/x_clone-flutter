import 'package:flutter/material.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/pages/post_page.dart';
import 'package:x_clone/pages/profile_page.dart';

void goUserPage(BuildContext context, int userId) {
  // navigate to the page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(userId: userId),
    ),
  );
}

// go to post page
void goPostPage(BuildContext context, PostModel post) {
  // navigate to the pages
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(post: post),
    ),
  );
}
