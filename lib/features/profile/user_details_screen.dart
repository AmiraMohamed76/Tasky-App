import 'package:flutter/material.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';

import '../../core/services/preferences_manager.dart';

class UserDetailsScreen extends StatefulWidget {
  final String username;
  final String motivationQuote;

  const UserDetailsScreen({
    super.key,
    required this.username,
    required this.motivationQuote,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController motivationQuoteController =
      TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    userNameController.text = widget.username;
    motivationQuoteController.text = widget.motivationQuote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: SafeArea(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: userNameController,
                          hintText: "Amira Mohamed",
                          title: "User Name",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter Your User Name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        CustomTextFormField(
                          controller: motivationQuoteController,
                          hintText: 'One task at a time. One step closer',
                          title: 'Motivation Quote',
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter Motivation Quote';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      await PreferencesManager().setString(
                        "username",
                        userNameController.value.text.trim(),
                      );
                      await PreferencesManager().setString(
                        "motivation_quote",
                        motivationQuoteController.value.text.trim(),
                      );

                      Navigator.of(context).pop(true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  ),
                  child: Text(
                    "Save Changes",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
