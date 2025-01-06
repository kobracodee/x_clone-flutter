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

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final Crud _crud = Crud();

  login(BuildContext context) async {
    Provider.of<UserProvider>(context, listen: false).setIsLoading(true);
    var response = await _crud
        .postRequest("${Constants.BASE_URL}${Constants.AUTH}/login.php", {
      Constants.EMAIL: emailController.text,
      Constants.PASSWORD: passwordController.text,
    });

    log(response.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
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

                // Welcome back message
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
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
                // sign in button
                const SizedBox(height: 45),

                !Provider.of<UserProvider>(context).isLoading
                    ? MyButton(
                        onTap: () async {
                          await login(context);
                        },
                        text: "L O G I N",
                      )
                    : const Center(child: CircularProgressIndicator()),

                // not a member? reqgister now
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register now",
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
    );
  }
}
