import 'package:flutter/material.dart';

class AddTask extends StatelessWidget {
  AddTask({super.key});

  //TODO: DISPOSE THIS CONTROLLERS
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: Color(0xFF181818),
        iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),
        title: Text("New Task"),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: Color(0xFFFFFCFC),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFFCFC),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: taskNameController,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please Enter your Task Name";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Finish UI design for login screen',
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
                SizedBox(height: 20),
                Text(
                  "Task Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFFCFC),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please Enter your Task Description";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText:
                        'Finish onboarding UI and hand off to devs by Thursday.',
                    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                    filled: true,
                    fillColor: Color(0xFF282828),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 5,
                  cursorColor: Colors.white,
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF15B86C),
                    foregroundColor: Color(0xFFFFFCFC),
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  ),
                  label: Text("Add Task"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
