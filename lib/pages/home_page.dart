// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_clone/helper/navigate_pages.dart';
import 'package:x_clone/pages/post_page.dart';
import 'package:x_clone/providers/post_provider.dart';
import 'package:x_clone/providers/user_provider.dart';
import 'package:x_clone/utilities/constants.dart';
import 'package:x_clone/widgets/my_drawer.dart';
import 'package:x_clone/widgets/my_input_alert_box.dart';
import 'package:x_clone/widgets/my_post_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final postController = TextEditingController();
  late UserProvider provider;
  late PostProvider listingProvider =
      Provider.of<PostProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    provider = Provider.of<UserProvider>(context, listen: false);
    fetchPosts();
    setState(() {});
  }

  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlretBox(
        textController: postController,
        onPressed: () async {
          // post
          post(postController.text).then((value) async {
            fetchPosts();
            // show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(value.toString()),
              ),
            );
          });
        },
        onPressedText: "Post",
        hintText: "What's on your mind?",
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  // fetch posts
  Future<void> fetchPosts() async {
    await listingProvider
        .fetchPosts("${Constants.BASE_URL}/${Constants.TWEETS}/all_posts.php");
  }

  // post
  Future<String> post(String content) async {
    return await provider.post(
        "${Constants.BASE_URL}/${Constants.TWEETS}/upload_post.php", content);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: const MyDrawer(),
        appBar: AppBar(
          title: Text(
            provider.userModel!.username,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: _openPostMessageBox,
          child:
              Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
        ),
        body: _buildPostList(),
      ),
    );
  }

  // build post list
  Widget _buildPostList() {
    return RefreshIndicator(
      onRefresh: () async {
        fetchPosts();
      },
      child: Consumer<PostProvider>(
        // future: fetchPosts(),
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (provider.allPosts.isEmpty) {
            return const Center(
              child: Text("No posts..."),
            );
          }
          return ListView.builder(
            itemCount: provider.allPosts.length,
            itemBuilder: (context, index) {
              // get each post
              final post = provider.allPosts[index];
              return MyPostTile(
                post: post,
                onUserTap: () => goUserPage(context, post.userId),
                onPostDelete: () async {
                  Navigator.pop(context);
                  fetchPosts();
                },
                onPostTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPage(post: post),
                    ),
                  ).then((updatedPost) {
                    if (updatedPost != null && mounted) {
                      setState(() {
                        int index = provider.allPosts
                            .indexWhere((p) => p.id == updatedPost.id);
                        if (index != -1) {
                          provider.allPosts[index] = updatedPost;
                        }
                      });
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
