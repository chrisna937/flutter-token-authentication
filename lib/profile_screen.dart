import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "John Doe";
  String email = "johndoe@example.com";
  String avatarUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //G
            GestureDetector(
              onTap: () {
                print("Change avatar tapped");
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(avatarUrl),
                child: const Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.edit,
                    color: Colors.white,
                    size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: name),
              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 16),

             TextField(
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: email),
              onChanged: (value) => email = value,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print("Profile saved: Name=$name, Email=$email");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile saved")),
                  );
                }
              , child: const Text("Save")),
            )
          ],
        ),
      ),
    );
  }
}