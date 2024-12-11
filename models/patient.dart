class Patient {
  final String name; // Patient's name
  final int id; // Unique identifier
  final int age; // Age (years)
  final String? email; // Email (optional)
  final String? phoneNumber; // Phone number (optional)
  final String? dermatoscopyImage; //dermatoscopy image from gallery or camera
  final String? diagnosisDate;
  final String? diagnosisTime;
  final String? diagnosisResult;

  // Constructor
  Patient({
    required this.name,
    required this.id,
    required this.age,
    this.email,
    this.phoneNumber,
    this.dermatoscopyImage,
    this.diagnosisDate,
    this.diagnosisTime,
    this.diagnosisResult,
  });
}
