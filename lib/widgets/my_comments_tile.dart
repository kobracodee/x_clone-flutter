// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:x_clone/models/comment_model.dart';
import 'package:x_clone/models/crud.dart';
import 'package:x_clone/providers/user_provider.dart';
import 'package:x_clone/utilities/constants.dart';

class MyCommentTile extends StatelessWidget {
  const MyCommentTile({
    super.key,
    required this.comment,
    required this.onUserTap,
    required this.onDelete,
  });

  final CommentModel comment;
  final void Function()? onUserTap;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    Crud crud = Crud();

    Future deleteComment(int commentId) async {
      // delete comment
      var response = await crud.postRequest(
        "${Constants.BASE_URL}/${Constants.TWEETS}/delete_comment.php",
        {
          "comment_id": commentId,
          Constants.TWEETID: comment.tweetId,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(response['message']),
        ),
      );
    }

    void showOptios(BuildContext context) {
      // logged in user
      final user = context.read<UserProvider>().userModel;
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                // delete post button
                user!.id == comment.user.id
                    ? ListTile(
                        leading: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: const Text("D E L E T E"),
                        onTap: () async {
                          await deleteComment(comment.commentId);
                          // pop the bottom sheet
                          onDelete();
                          Navigator.pop(context);
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
                      ClipboardData(text: comment.commentContent),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onUserTap,
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
                  comment.user.username,
                  style: TextStyle(
                    color: theme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),

                // Icon more options
                GestureDetector(
                  onTap: () => showOptios(context),
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
            comment.commentContent,
            style: TextStyle(
              color: theme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
