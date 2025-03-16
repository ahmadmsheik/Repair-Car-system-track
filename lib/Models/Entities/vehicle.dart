import 'dart:convert';

class Vehicle {
  int? id;
  String? vin;
  int plateNumber;
  String make;
  String model;
  int? year;
  String? engineType;
  int? mileage;
  String? imagePath; // Add this field
  final int? userId;

  Vehicle({
    this.id,
    this.vin,
    required this.plateNumber,
    required this.make,
    required this.model,
    this.year,
    this.engineType,
    this.mileage,
    this.imagePath, // Add this field
    this.userId,
  });

  // Convert Vehicle object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vin': vin,
      'plate_number': plateNumber,
      'make': make,
      'model': model,
      'year': year,
      'engine_type': engineType,
      'mileage': mileage,
      'image_path': imagePath, // Add this field
      'user_id': userId,
    };
  }

  // Convert a map to a Vehicle object
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      vin: map['vin'],
      plateNumber: map['plate_number'],
      make: map['make'],
      model: map['model'],
      year: map['year'],
      engineType: map['engine_type'],
      mileage: map['mileage'],
      imagePath: map['image_path'], // Add this field
      userId: map['user_id'],
    );
  }

  // Convert Vehicle object to JSON
  String toJson() => json.encode(toMap());

  // Convert JSON to Vehicle object
  factory Vehicle.fromJson(String source) => Vehicle.fromMap(json.decode(source));
}