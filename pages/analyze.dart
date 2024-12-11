import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/result_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result_screen.dart';

class Analyze extends StatefulWidget {
  final File? data;

  Analyze({required this.data});

  @override
  _AnalyzeState createState() => _AnalyzeState();
}

class _AnalyzeState extends State<Analyze> {
  @override
  void initState() {
    super.initState();
    _sendImageToServer(); // Trigger the image sending on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Analyze",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Analyzing...",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            widget.data == null
                ? const Text("No Image to be analyzed")
                : Image.file(
                    widget.data!,
                    width: 500,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendImageToServer() async {
    if (widget.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
      return;
    }

    try {
      final uri = Uri.parse(
          'http://192.168.27.146:3000/predict'); // Replace with your server's address
      var request = http.MultipartRequest('POST', uri);

      var imageFile =
          await http.MultipartFile.fromPath('image', widget.data!.path);
      request.files.add(imageFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final decodedResponse = jsonDecode(responseData.body);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       content: Text("Prediction: ${decodedResponse['prediction']}")),
        // );
        final predictionList = decodedResponse['prediction'];

        if (predictionList is List && predictionList.isNotEmpty) {
          // Access the first element if it is also a List
          final innerList = predictionList[0];
          if (innerList is List && innerList.isNotEmpty) {
            final prediction = innerList[0] * 100; // Access the first value
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                    prediction: prediction.toString(),
                    image: widget.data!.path),
              ),
            );
            print("Prediction: $prediction");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Prediction: $prediction")),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to get prediction from server")),
        );
      }
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => Analyze(data: AIresponse)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
