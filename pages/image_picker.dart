import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'login_screen.dart';
import 'analyze.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImagePick extends StatefulWidget {
  @override
  State<ImagePick> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Image"),
        backgroundColor: Colors.amber[200],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 254, 250),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            color: Colors.amber[300],
            child: const Text(
              "Pick Image from Gallery",
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {
              _pickImageFromGallery();
            },
          ),
          MaterialButton(
            color: Colors.amber[300],
            child: const Text(
              "Pick Image from Camera",
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {
              _pickImageFromCamera();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          _selectedImage != null
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.file(
                        _selectedImage!,
                        width: 500,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            color: Colors.amber[300],
                            child: const Text(
                              "Start Analyze",
                              style: TextStyle(color: Colors.black87),
                            ),
                            onPressed: () {
                              // _sendImageToServer();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Analyze(data: _selectedImage)));
                            },
                          ),
                          MaterialButton(
                            color: Colors.amber[300],
                            child: const Text(
                              "Remove Photo",
                              style: TextStyle(color: Colors.black87),
                            ),
                            onPressed: () {
                              _removePhoto();
                            },
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                              color: Colors.amber[300],
                              child: const Text(
                                "Store to Cloud",
                                style: TextStyle(color: Colors.black87),
                              ),
                              onPressed: () {
                                // _uploadImageToCloud();
                              }),
                        ],
                      )
                    ],
                  ),
                )
              : const Text("Please select an image"),
        ],
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future _removePhoto() async {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _sendImageToServer() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
      return;
    }

    try {
      final uri = Uri.parse(
          'http://10.0.2.2:3000/predict'); // Replace with your server address
      var request = http.MultipartRequest('POST', uri);

      // Attach the selected image file
      var imageFile =
          await http.MultipartFile.fromPath('image', _selectedImage!.path);
      request.files.add(imageFile);

      // Send the request and wait for the response
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final decodedResponse = jsonDecode(responseData.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Prediction: ${decodedResponse['prediction']}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to get prediction from server")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Backend code
  // Future<void> _uploadImageToCloud() async {
  //   if (_selectedImage == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("No image selected")),
  //     );
  //     return;
  //   }

  //   try {
  //     // Create a reference to the storage bucket
  //     final storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');

  //     // Upload the file
  //     final uploadTask = storageRef.putFile(_selectedImage!);

  //     // Monitor the upload and show progress or errors
  //     await uploadTask.whenComplete(() async {
  //       final downloadUrl = await storageRef.getDownloadURL();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Upload successful! URL: $downloadUrl")),
  //       );
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to upload: $e")),
  //     );
  //   }
  // }
}
