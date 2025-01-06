import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_clone/helper/navigate_pages.dart';
import 'package:x_clone/models/comment_model.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/providers/post_provider.dart';
import 'package:x_clone/providers/user_provider.dart';
import 'package:x_clone/utilities/constants.dart';
import 'package:x_clone/widgets/my_comments_tile.dart';
import 'package:x_clone/widgets/my_post_tile.dart';

class PostPage extends StatefulWidget {
  const PostPage({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late PostProvider listingProvider =
      Provider.of<PostProvider>(context, listen: false);
  late Future<List<CommentModel>> comments;
  late UserProvider provider =
      Provider.of<UserProvider>(context, listen: false);

  final commentController = TextEditingController();

  Future<List<CommentModel>> fetctComment() async {
    return await listingProvider.getCommentForPost(
        "${Constants.BASE_URL}/${Constants.TWEETS}/comments_post.php",
        widget.post.id);
  }

  @override
  void initState() {
    super.initState();
    comments = fetctComment();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context, widget.post);
          },
        ),
        foregroundColor: theme.primary,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          comments = fetctComment();
          setState(() {});
        },
        child: ListView(
          children: [
            // Post
            MyPostTile(
              post: widget.post,
              onUserTap: () => goUserPage(context, widget.post.userId),
              onPostDelete: () {
                listingProvider.removePost(widget.post);
                // pop the page
                Navigator.pop(context);
                Navigator.pop(context, widget.post);
              },
              onPostTap: () {},
            ),

            // display comments
            FutureBuilder<List<CommentModel>>(
              future: comments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text("No comments"),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Failed to fetch posts"),
                  );
                }
                final comments = snapshot.data;
                return ListView.builder(
                  itemCount: comments!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // get comment
                    final comment = comments[index];

                    // return the ui of comments
                    return MyCommentTile(
                      comment: comment,
                      onUserTap: () => goUserPage(context, comment.user.id),
                      onDelete: () {
                        // decrement comment count
                        listingProvider
                            .decrementCommentCountPost(comment.tweetId);
                        comments.removeAt(index);
                        setState(() {});
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
