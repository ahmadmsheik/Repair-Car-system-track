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
      'start_time': timeStart.toIso8601String(),
      'end_time': timeEnd?.toIso8601String(),
      'cost': cost,
      'details': details,
      'vehicle_id': vehicleId,
    };
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    name: json['name'] as String,
    status: json['status'] as String,
    timeStart: DateTime.parse(
      (json['start_time'] as String).replaceAll(' ', 'T'),
    ),
    timeEnd:
        json['end_time'] != null
            ? DateTime.parse((json['end_time'] as String).replaceAll(' ', 'T'))
            : null,
    cost: (json['cost'] as num).toDouble(),
    details: json['details']?.toString(),
    vehicleId: json['vehicle_id'] as int,
  );

  // Add this to maintain consistency
  factory Task.fromMap(Map<String, dynamic> map) => Task.fromJson(map);
}
