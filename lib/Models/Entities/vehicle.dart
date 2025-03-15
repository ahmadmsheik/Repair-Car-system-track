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
   int? userId;

  Vehicle(
      {this.id,
      this.vin,
      required this.plateNumber,
      required this.make,
      required this.model,
      this.year,
      this.engineType,
      this.mileage,
      this.userId});

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
      'user_id': userId,
    };
  }

  String toJson() => json.encode(toMap());
}
