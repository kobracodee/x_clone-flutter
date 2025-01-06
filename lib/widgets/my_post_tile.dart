// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:x_clone/models/crud.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/providers/post_provider.dart';
import 'package:x_clone/providers/user_provider.dart';
import 'package:x_clone/utilities/constants.dart';
import 'package:x_clone/widgets/my_input_alert_box.dart';

class MyPostTile extends StatefulWidget {
  const MyPostTile({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
    required this.onPostDelete,
  });

  final PostModel post;
  final void Function() onUserTap;
  final void Function() onPostTap;
  final void Function() onPostDelete;

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  final Crud _crud = Crud();

  late UserProvider provider =
      Provider.of<UserProvider>(context, listen: false);
  late PostProvider listingProvider =
      Provider.of<PostProvider>(context, listen: false);

  final commentController = TextEditingController();

  Future<void> likePost(int postId, int userId) async {
    await listingProvider.likePost(postId, userId);
    widget.post.likedby.add(userId);
    widget.post.likeCount++;
  }

  Future<void> removeLikeForPost(int postId, int userId) async {
    await listingProvider.removeLike(postId, userId);
    widget.post.likedby.remove(userId);
    widget.post.likeCount--;
  }

  // Future<List<CommentModel>> getCommentForPost() async {
  //   var comments = await listingProvider.getCommentForPost(
  //       "${Constants.BASE_URL}/${Constants.TWEETS}/comments_post.php",
  //       widget.post.id);

  //   return comments;
  // }

  Future<void> deletePost(int postId) async {
    var response = await _crud.postRequest(
      "${Constants.BASE_URL}/${Constants.TWEETS}/delete_post.php",
      {
        Constants.POSTID: postId,
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response[Constants.MESSAGE]),
      ),
    );
  }

  void _openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlretBox(
        textController: commentController,
        onPressed: () async {
          await addComment(
            "${Constants.BASE_URL}/${Constants.TWEETS}/add_comment.php",
            widget.post.id,
            provider.userModel!.id,
            commentController.text.trim().toString(),
          );
          listingProvider.incrementCommentCountPost(widget.post);
          setState(() {});
        },
        onPressedText: "Post",
        hintText: "Type a comment...",
      ),
    );
  }

  // post a comment
  Future<void> addComment(
      String url, int postId, int userId, String comment) async {
    String message =
        await listingProvider.addCommentToPost(url, postId, userId, comment);
    // display message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showOptios() {
    // logged in user
    final user = context.read<UserProvider>().userModel;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // delete post button
              user!.id == widget.post.userId
                  ? ListTile(
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title: const Text("D E L E T E"),
                      onTap: () async {
                        await deletePost(widget.post.id);
                        widget.onPostDelete();
                      },
                    )
                  : const SizedBox.shrink(),
              // cancel button
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("C O P Y"),
                onTap: () {
                  // copy to clipboard
                  Clipboard.setData(
                    ClipboardData(text: widget.post.content),
                  );
                  // pop the bottom sheet
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Post Copied'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("C A N C E L"),
                onTap: () {
                  // pop the bottom sheet
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> toggleLike(int postId, int userId) async {
    if (widget.post.likedby.contains(userId)) {
      await listingProvider.removeLike(postId, userId);
      setState(() {
        widget.post.likedby.remove(userId);
        widget.post.likeCount--;
      });
    } else {
      await listingProvider.likePost(postId, userId);
      setState(() {
        widget.post.likedby.add(userId);
        widget.post.likeCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  // profile pic
                  Icon(
                    Icons.person,
                    color: theme.primary,
                  ),
                  const SizedBox(width: 5),
                  // username
                  Text(
                    widget.post.username.isEmpty
                        ? "Loading..."
                        : widget.post.username,
                    style: TextStyle(
                      color: theme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),

                  // Icon more options
                  GestureDetector(
                    onTap: _showOptios,
                    child: Icon(
                      Icons.more_vert,
                      color: theme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // content
            Text(
              widget.post.content.isEmpty ? "Loading..." : widget.post.content,
              style: TextStyle(
                color: theme.inversePrimary,
              ),
            ),

            const SizedBox(height: 20),

            // buttons like and comment
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: GestureDetector(
                    onTap: () =>
                        toggleLike(widget.post.id, provider.userModel!.id),
                    child: Row(
                      children: [
                        // like button
                        widget.post.likedby.contains(provider.userModel!.id)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.pink,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: theme.primary,
                              ),

                        const SizedBox(width: 5),

                        // like count
                        Text(
                          widget.post.likeCount.toString(),
                          style: TextStyle(
                            color: theme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // comment section
                GestureDetector(
                  onTap: _openNewCommentBox,
                  child: Row(
                    children: [
                      // comment button
                      Icon(
                        CupertinoIcons.chat_bubble_2_fill,
                        color: theme.primary,
                      ),

                      const SizedBox(width: 5),

                      // comment count
                      Text(
                        widget.post.commentCount.toString(),
                        style: TextStyle(
                          color: theme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
