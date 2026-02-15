import 'package:flutter/material.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/services/theme_controller.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/screens/user_details_screen.dart';
import 'package:tasky_app/screens/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String motivationQuote;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      username = PreferencesManager().getString("username") ?? "";
      motivationQuote =
          PreferencesManager().getString("motivation_quote") ??
          "One task at a time. One step closer";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "My Profile",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/person.png"),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Center(
                          child: CustomSvgPicture(
                            imagePath: "assets/images/camera.svg",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                isLoading
                    ? CircularProgressIndicator()
                    : Column(
                        children: [
                          Text(
                            username,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          SizedBox(height: 4),
                          Text(
                            motivationQuote,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text("Profile Info", style: Theme.of(context).textTheme.labelSmall),
          ListTile(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return UserDetailsScreen(
                      username: username,
                      motivationQuote: motivationQuote,
                    );
                  },
                ),
              );
              if (result != null && result) {
                _loadData();
              }
            },
            title: Text("User Details"),
            leading: CustomSvgPicture(imagePath: "assets/images/profile.svg"),
            trailing: CustomSvgPicture(imagePath: "assets/images/arrow.svg"),
            contentPadding: EdgeInsets.zero,
          ),
          Divider(),
          ListTile(
            title: Text("Dark Mode"),
            leading: CustomSvgPicture(imagePath: "assets/images/dark.svg"),
            trailing: ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeController.themeNotifier,
              builder: (BuildContext context, value, Widget? child) {
                return Switch(
                  value: value == ThemeMode.dark,
                  // check if theme is dark (true) or light (false)
                  onChanged: (bool value) async {
                    ThemeController.toggleTheme();
                  },
                );
              },
            ),
            contentPadding: EdgeInsets.zero,
          ),
          Divider(),
          ListTile(
            onTap: () async {
              PreferencesManager().remove("username");
              PreferencesManager().remove("motivation_quote");
              PreferencesManager().remove("tasks");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return WelcomeScreen();
                  },
                ),
                (Route<dynamic> route) => false,
              );
            },
            title: Text("Log Out"),
            leading: CustomSvgPicture(imagePath: "assets/images/log_out.svg"),
            trailing: CustomSvgPicture(imagePath: "assets/images/arrow.svg"),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
