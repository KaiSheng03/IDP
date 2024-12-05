import 'package:flutter/material.dart';
import 'patient_list_screen.dart';
import 'image_picker.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skinalyze'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // First button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Navigate to the AI analysing screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImagePick()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[100], //background color
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/dermatoscope_icon.png', // Replace with your image
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Image Analysis AI Assistance',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Second button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Navigate to the patient list screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PatientsListScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[100], //background color
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/EHR_icon.png', // Replace with your image
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Patient Medical Record',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
