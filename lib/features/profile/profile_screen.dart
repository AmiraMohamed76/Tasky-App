import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/services/theme_controller.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/features/profile/user_details_screen.dart';
import 'package:tasky_app/features/welcome/welcome_screen.dart';

import '../../core/constants/storage_key.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String motivationQuote;
  String? userImagePath;
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
      username = PreferencesManager().getString(StorageKey.userName) ?? "";
      motivationQuote = PreferencesManager().getString("motivation_quote") ?? "One task at a time. One step closer";
      userImagePath = PreferencesManager().getString("user_image");
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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "My Profile",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: userImagePath == null
                            ? AssetImage("assets/images/person.png")
                            : FileImage(File(userImagePath!)),
                        radius: 60,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        showImageSourceDialog(context , (XFile file){
                          // save file
                          _saveImage(file);
                          setState(() {
                            userImagePath = file.path;
                          });
                        });
                      },
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
              PreferencesManager().remove(StorageKey.userName);
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

  void _saveImage(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy('${appDir.path}/${file.name}');
    PreferencesManager().setString("user_image", newFile.path);
  }
}

void showImageSourceDialog(BuildContext context, Function(XFile) selectedFile) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Choose Image Source",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                selectedFile(image);
              }
            },
            child: Row(
              children: [
                CustomSvgPicture(imagePath: "assets/images/camera.svg"),
                SizedBox(width: 8),
                Text("Camera", style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          SizedBox(height: 10),
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                selectedFile(image);
              }
            },
            child: Row(
              children: [
                Icon(Icons.photo_library_outlined),
                SizedBox(width: 8),
                Text("Gallery", style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      );
    },
  );
}
