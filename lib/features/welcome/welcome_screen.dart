import 'package:flutter/material.dart';
import 'package:tasky_app/core/constants/storage_key.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';
import 'package:tasky_app/features/navigation/main_screen.dart';

import '../../core/constants/app_sizes.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: AppSizes.h16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSvgPicture.withoutColor(
                        imagePath: "assets/images/logo.svg",
                        height: AppSizes.h42,
                        width: AppSizes.w42,
                      ),
                      SizedBox(width: AppSizes.w16),
                      Text(
                        "Tasky",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h108),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome To Tasky ",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      CustomSvgPicture.withoutColor(
                        imagePath: "assets/images/waving_hand.svg",
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h8),
                  Text(
                    "Your productivity journey starts here.",
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall!.copyWith(fontSize: AppSizes.sp16),
                  ),
                  SizedBox(height: AppSizes.h24),
                  CustomSvgPicture.withoutColor(
                    imagePath: "assets/images/welcome.svg",
                    width: AppSizes.w200,
                    height: AppSizes.h200,
                  ),
                  SizedBox(height: AppSizes.h24),
                  Padding(
                    padding: EdgeInsets.all(AppSizes.w16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          controller: controller,
                          hintText: 'e.g. Sarah Khalid',
                          title: "Full Name",
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please Enter your Full Name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSizes.h24),
                        ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState?.validate() ?? false) {
                              await PreferencesManager().setString(
                                StorageKey.userName,
                                controller.value.text,
                              );
                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                // Because it's welcome screen and i don't want user to get back on it
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return MainScreen();
                                  },
                                ),
                              );
                            }
                          },
                          child: Text("Let’s Get Started"),
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
