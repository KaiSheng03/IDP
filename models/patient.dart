class Patient {
  final String name; // Patient's name
  final int id; // Unique identifier
  final String? email; // Email (optional)
  final String? phoneNumber; // Phone number (optional)
  final String? dermatoscopyImage;
  final String? diagnosisResult;

  // Constructor
  Patient({
    required this.name,
    required this.id,
    this.email,
    this.phoneNumber,
    this.dermatoscopyImage,
    this.diagnosisResult,
  });
}
