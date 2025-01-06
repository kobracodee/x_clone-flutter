import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_clone/pages/home_page.dart';
import 'package:x_clone/providers/post_provider.dart';
import 'package:x_clone/providers/user_provider.dart';
import 'package:x_clone/service/auth/login_regiser.dart';
import 'package:x_clone/themes/theme_provider.dart';
import 'package:x_clone/utilities/constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        Constants.homePage: (context) => const HomePage(),
        Constants.loginOrRegister: (context) => const LoginOrRegister(),
      },
    );
  }
}
