import 'dart:convert';

enum Status { pending, completed, onGoing }

class Task {
  final int? id;
  final String name;
  final String status;
  final DateTime timeStart;
  final DateTime? timeEnd;
  final double cost;
  final String? details;
  final int? vehicleId;

  Task({
    this.id,
    required this.name,
    required this.status,
    required this.timeStart,
    this.timeEnd,
    required this.cost,
    this.details,
    this.vehicleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'time_start': timeStart.toIso8601String(),
      'time_end': timeEnd?.toIso8601String(),
      'cost': cost,
      'details': details,
      'vehicle_id': vehicleId,
    };
  }

  String toJson() => json.encode(toMap());
}
