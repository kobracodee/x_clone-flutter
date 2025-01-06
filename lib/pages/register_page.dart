// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_clone/models/crud.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/providers/user_provider.dart';
import 'package:x_clone/utilities/constants.dart';
import 'package:x_clone/widgets/my_button.dart';
import 'package:x_clone/widgets/my_textfield.dart';

class RegiserPage extends StatefulWidget {
  const RegiserPage({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  @override
  State<RegiserPage> createState() => _RegiserPageState();
}

class _RegiserPageState extends State<RegiserPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final Crud _crud = Crud();
  String message = "";

  register(BuildContext context) async {
    Provider.of<UserProvider>(context, listen: false).setIsLoading(true);
    bool valid = validateForm();
    if (!valid) {
      Provider.of<UserProvider>(context, listen: false).setIsLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.toString()),
        ),
      );
      return;
    }
    var response = await _crud
        .postRequest("${Constants.BASE_URL}${Constants.AUTH}/register.php", {
      Constants.USERNAME: usernameController.text,
      Constants.EMAIL: emailController.text,
      Constants.PASSWORD: passwordController.text,
    });

    Provider.of<UserProvider>(context, listen: false).setIsLoading(false);

    if (response[Constants.SUCCESS] == 'true') {
      log(response.toString());
      var user = UserModel.fromJson(response[Constants.USER]);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Constants.homePage, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[Constants.MESSAGE].toString()),
        ),
      );
    }
  }

  bool validateForm() {
    if (usernameController.text.isEmpty) {
      message = "Username cannot be empty";
      return false;
    }
    if (emailController.text.isEmpty) {
      message = "Email cannot be empty";
      return false;
    }
    if (passwordController.text.isEmpty) {
      message = "Password cannot be empty";
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      message = "Confirm Password cannot be empty";
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      message = "Passwords do not match";
      return false;
    }
    if (passwordController.text.length < 6) {
      message = "Password must be at least 6 characters";
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  Icon(
                    Icons.lock_open_rounded,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 50),

                  // create an account
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // email textfield
                  MyTextField(
                    controller: usernameController,
                    hintText: "Enter Name",
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),
                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: "Enter Email",
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),
                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: "Enter Password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  // sign up button
                  const SizedBox(height: 45),

                  !Provider.of<UserProvider>(context).isLoading
                      ? MyButton(
                          onTap: () async {
                            await register(context);
                          },
                          text: "R E G I S T E R")
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),

                  // already a member? login
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login now",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
