import 'dart:convert';

class Vehicle {
  int? id;
  String vin;
  int plateNumber;
  String make;
  String model;
  int year;
  String? engineType;
  int? mileage;
  String imagePath;
  final int clientId;

  Vehicle({
    this.id,
    required this.vin,
    required this.plateNumber,
    required this.make,
    required this.model,
    required this.year,
    this.engineType,
    this.mileage,
    required this.imagePath,
    required this.clientId,
  });

  Vehicle copyWith({
    int? id,
    String? vin,
    int? plateNumber,
    String? make,
    String? model,
    int? year,
    String? engineType,
    int? mileage,
    String? imagePath,
    int? userId,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vin: vin ?? this.vin,
      plateNumber: plateNumber ?? this.plateNumber,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      engineType: engineType ?? this.engineType,
      mileage: mileage ?? this.mileage,
      imagePath: imagePath ?? this.imagePath,
      clientId: userId ?? clientId,
    );
  }

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
      'image_path': imagePath,
      'client_id': clientId,
    };
  }

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
      imagePath: map['image_path'],
      clientId: map['client_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json['id'],
    vin: json['vin'] as String, // Ensure non-null
    plateNumber: json['plate_number'] as int,
    make: json['make'] as String,
    model: json['model'] as String,
    year: json['year'] as int,
    engineType: json['engine_type']?.toString(), // Allow null
    mileage:
        json['mileage'] != null
            ? int.tryParse(json['mileage'].toString())
            : null,
    imagePath:
        json['image_path'].isEmpty
            ? 'assets/images/car.png'
            : json['image_path'].toString(),
    clientId: json['client_id'] as int,
  );
}
