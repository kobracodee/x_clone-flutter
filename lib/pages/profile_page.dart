// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_clone/helper/navigate_pages.dart';
import 'package:x_clone/models/crud.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/pages/home_page.dart';
import 'package:x_clone/providers/post_provider.dart';
import 'package:x_clone/providers/user_provider.dart';
import 'package:x_clone/utilities/constants.dart';
import 'package:x_clone/widgets/my_biobox.dart';
import 'package:x_clone/widgets/my_input_alert_box.dart';
import 'package:x_clone/widgets/my_post_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.userId,
  });

  final int userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bioTextController = TextEditingController();
  final Crud _crud = Crud();

  late final listingProvider = Provider.of<PostProvider>(context);

  void _showEditBioBox(provider) async {
    showDialog(
      context: context,
      builder: (context) => MyInputAlretBox(
        textController: bioTextController,
        onPressed: () async {
          await saveBio(provider); // Call the saveBio method here
        },
        onPressedText: "Save",
        hintText: "Edit bio..",
      ),
    );
  }

  Future<void> saveBio(provider) async {
    var response = await _crud.postRequest(
        "${Constants.BASE_URL}/${Constants.USERAPI}/update_bio.php", {
      Constants.USER_ID: provider.userModel!.id,
      Constants.BIO: bioTextController.text.toString(),
    });

    if (response[Constants.SUCCESS] == "true") {
      var user = UserModel.fromJson(response[Constants.USER]);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[Constants.MESSAGE].toString()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[Constants.MESSAGE].toString()),
        ),
      );
    }
  }

  late final user = listingProvider.getUserById(widget.userId);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>();
    final theme = Theme.of(context).colorScheme;

    final allUserPosts = listingProvider.filterUserPosts(widget.userId);
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            ).then((_) {
              listingProvider.fetchPosts(
                  "${Constants.BASE_URL}/${Constants.TWEETS}/all_posts.php");
            });
          },
        ),
        centerTitle: true,
        title: const Text("P R O F I L E"),
        foregroundColor: theme.primary,
      ),
      body: FutureBuilder<UserModel>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No user found."),
            );
          }
          final user = snapshot.data!;
          final isCurrentUser = user.id == currentUser.userModel!.id
              ? currentUser.userModel
              : user;
          return ListView(
            children: [
              // username
              Center(
                child: Text(
                  "@${isCurrentUser!.username}",
                  style: TextStyle(
                    color: theme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // profile picture
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: Icon(
                    Icons.person,
                    size: 72,
                    color: theme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // profile status -> number of postes / followers / following

              // follow / unfollow button

              // edit bio
              currentUser.userModel!.id == user.id
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bio",
                            style: TextStyle(
                              color: theme.primary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showEditBioBox(currentUser);
                            },
                            child: Icon(
                              Icons.settings,
                              color: theme.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),

              const SizedBox(height: 10),
              // bio box
              MyBioBox(
                text: isCurrentUser.bio.isEmpty
                    ? "No bio yet..."
                    : isCurrentUser.bio,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25, top: 25),
                child: Text("Posts", style: TextStyle(color: theme.primary)),
              ),

              // list for postes
              allUserPosts.isEmpty
                  ?

                  //user post is empty
                  const Center(
                      child: Text("No posts yet..."),
                    )
                  :
                  // user post in not empty
                  ListView.builder(
                      itemCount: allUserPosts.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // get individual post
                        final myPost = allUserPosts[index];

                        // post tile ui
                        return MyPostTile(
                          post: myPost,
                          onUserTap: () {},
                          onPostDelete: () {
                            listingProvider.removePost(myPost);
                            Navigator.pop(context);
                            setState(() {});
                          },
                          onPostTap: () => goPostPage(context, myPost),
                        );
                      },
                    ),
            ],
          );
        },
      ),
    );
  }
}
