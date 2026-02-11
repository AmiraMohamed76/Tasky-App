import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
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
              style: TextStyle(color: Color(0xFFFFFCFC), fontSize: 20),
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
                          color: Color(0xFF282828),
                        ),

                        child: Center(
                          child: SvgPicture.asset(
                            "assets/images/camera.svg",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "$username",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFFCFC),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "One task at a time. One step closer.",
                  style: TextStyle(
                    color: Color(0xFFFFFCFC),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Profile Info",
            style: TextStyle(
              color: Color(0xFFFFFCFC),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          ListTile(
            onTap: () {},
            title: Text(
              "User Details",
              style: TextStyle(
                color: Color(0xFFFFFCFC),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: SvgPicture.asset("assets/images/profile.svg"),
            trailing: SvgPicture.asset("assets/images/arrow.svg"),
            contentPadding: EdgeInsets.zero,
          ),
          Divider(color: Color(0xFF6E6E6E), thickness: 1),
          ListTile(
            title: Text(
              "Dark Mode",
              style: TextStyle(
                color: Color(0xFFFFFCFC),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: SvgPicture.asset("assets/images/dark.svg"),
            trailing: Switch(
              // activeTrackColor: Color(0xFF15B86C),
              value: isDarkMode,
              onChanged: (bool value) {
                // ToDo: Change Dark theme
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
            contentPadding: EdgeInsets.zero,
          ),
          Divider(color: Color(0xFF6E6E6E), thickness: 1),
          ListTile(
            onTap: () {
              //ToDo: Logout
            },
            title: Text(
              "Log Out",
              style: TextStyle(
                color: Color(0xFFFFFCFC),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: SvgPicture.asset("assets/images/log_out.svg"),
            trailing: SvgPicture.asset("assets/images/arrow.svg"),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
