import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/screens/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
   WelcomeScreen({super.key});

   final TextEditingController controller = TextEditingController();
   final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181818),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/logo.svg",
                        height: 42,
                        width: 42,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Tasky",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 118),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome To Tasky ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFFFCFC),
                        ),
                      ),
                      SvgPicture.asset("assets/images/waving_hand.svg"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your productivity journey starts here.",
                    style: TextStyle(
                      color: Color(0xFFFFFCFC),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 24),
                  SvgPicture.asset(
                    "assets/images/welcome.svg",
                    width: 215,
                    height: 200,
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Full Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: controller,
                          validator: (String? value){
                            if(value == null || value.trim().isEmpty){
                              return "Please Enter your Full Name";
                            }
                             return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'e.g. Sarah Khalid',
                            hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                            filled: true,
                            fillColor: Color(0xFF282828),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          cursorColor: Colors.white,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            if(_key.currentState?.validate() ?? false){
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString("username", controller.value.text);

                              Navigator.pushReplacement( // Because it's welcome screen and i don't want user to get back on it
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return HomeScreen();
                                  },
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xFFFFFCFC),
                            backgroundColor: Color(0xFF15B86C),
                            fixedSize: Size(MediaQuery.of(context).size.width, 40),
                          ),
                          child: Text(
                            "Let’s Get Started",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
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
