import 'package:flutter/material.dart';
import 'patient_list_screen.dart';
import 'image_picker.dart';
import 'state/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserProvider>(context).userInfo;
    return Scaffold(
      appBar: AppBar(
        title: Text('Wekcome, ${userInfo?['name']}'),
        backgroundColor: Colors.amber[200],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 254, 250),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First button
            GestureDetector(
              onTap: () {
                // Navigate to the AI analysing screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImagePick()),
                );
              },
              child: Container(
                height: 250, //Set box height
                width: 250, //Set box width
                decoration: BoxDecoration(
                  color: Colors.amber[100], //background color
                  borderRadius: BorderRadius.circular(16.0), //Round corners
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/dermatoscope_icon.png', // Replace with your image
                      height: 120,
                      width: 120,
                    ),
                    SizedBox(height: 8), // Space between image and text
                    Text(
                      'AI Dermatoscopy',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 25),

            // Second button
            GestureDetector(
              onTap: () {
                // Navigate to the AI analysing screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientsListScreen()),
                );
              },
              child: Container(
                height: 250, //Set box height
                width: 250, //Set box width
                decoration: BoxDecoration(
                  color: Colors.amber[100], //background color
                  borderRadius: BorderRadius.circular(16.0), //Round corners
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/EHR_icon.png', // Replace with your image
                      height: 120,
                      width: 120,
                    ),
                    SizedBox(height: 8), // Space between image and text
                    Text(
                      'Patient Medical Record',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
