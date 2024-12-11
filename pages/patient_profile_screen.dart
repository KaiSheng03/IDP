import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import '../models/patient.dart'; // Import Patient model

class PatientProfileScreen extends StatelessWidget {
  final Patient patient;

  PatientProfileScreen({super.key, required this.patient});

  // Function to determine the color based on malignancy percentage
  Color _getMalignancyColor(double percentage) {
    if (percentage > 50) {
      return Colors.red; // High malignancy (red)
    } else {
      return Colors.green; // Low malignancy (green)
    }
  }

  // Fetching medical records from Firestore
  Future<List<Map<String, dynamic>>> _fetchMedicalRecords() async {
    final records = await FirebaseFirestore.instance
        .collection('patients')
        .doc(patient.id.toString()) // Use patient ID as document ID
        .collection('records') // Access nested "records" collection
        .orderBy('timestamp',
            descending: true) // Fetch the latest records first
        .get();

    return records.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient.name}\'s Medical Record'),
        backgroundColor: Colors.amber[200],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 254, 250),
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Fixed padding syntax here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Personal details section
            Text(
              'Personal Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'ID: ${patient.id}',
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 5),
            Text(
              'Name: ${patient.name}',
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 5),
            Text(
              'Age: ${patient.age}',
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 5),
            Text(
              'Email: ${patient.email ?? "Not available"}',
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 5),
            Text(
              'Phone No.: ${patient.phoneNumber ?? "Not available"}',
              style: TextStyle(fontSize: 17),
            ),

            SizedBox(height: 20),

            // Fetch and display medical records section
            Text(
              'Medical Records',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 0),

            // Use FutureBuilder to fetch and display the records
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchMedicalRecords(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No medical records available.'));
                }

                final records = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      final String imageUrl = record['image_url'] ?? '';
                      final double malignancy =
                          double.tryParse(record['prediction'].toString()) ??
                              0.0;
                      final timestamp =
                          record['timestamp']?.toDate() ?? DateTime.now();

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ${timestamp.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Time: ${timestamp.toLocal().toString().split(' ')[1]?.substring(0, 5)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // Display the image from Firestore
                                if (imageUrl.isNotEmpty)
                                  Expanded(
                                    flex: 1,
                                    child: Image.network(
                                      imageUrl,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(width: 16),
                                // Display the malignancy details
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Malignancy:',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: malignancy / 100,
                                              color: _getMalignancyColor(
                                                  malignancy),
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${malignancy.toStringAsFixed(2)}%',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
