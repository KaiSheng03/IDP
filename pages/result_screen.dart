import 'package:flutter/material.dart';
import 'dart:io';

class ResultScreen extends StatelessWidget {
  final String prediction;
  final String image; // Path to the image

  const ResultScreen(
      {super.key, required this.prediction, required this.image});

  Color _getMalignancyColor(double percentage) {
    return percentage > 50 ? Colors.red : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final double malignancyPercentage = double.tryParse(prediction) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Result'),
        backgroundColor: Colors.amber[200],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 254, 250),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the image using Image.file
            Image.file(
              File(image),
              // height: 250,
              // width: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 30),

            Text(
              'Malignancy:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            Row(
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 15,
                    child: LinearProgressIndicator(
                      value: malignancyPercentage / 100,
                      color: _getMalignancyColor(malignancyPercentage),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
            const SizedBox(height: 25),

            Text(
              '${malignancyPercentage.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[300],
                foregroundColor: Colors.black87,
              ),
              child: const Text('Take Another Image',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
