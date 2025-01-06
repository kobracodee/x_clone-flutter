import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_clone/themes/theme_provider.dart';
import 'package:x_clone/widgets/my_setting_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("S E T T I N G S"),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Column(
          children: [
            // Dark Mode tile
            MySettingTile(
              title: "D A R K   M O D E",
              action: CupertinoSwitch(
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
                value: Provider.of<ThemeProvider>(context, listen: false)
                    .isDarkMode,
              ),
            ),
            // Block user tile

            // Account settings tile
          ],
        ),
      ),
    );
  }
}
