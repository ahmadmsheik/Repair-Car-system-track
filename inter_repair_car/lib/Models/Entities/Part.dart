import 'dart:convert';

class Part {
  final int? id;
  final String name;
  final String supplier;
  final double price;
  final int taskId;

  Part({
    this.id,
    required this.name,
    required this.supplier,
    required this.price,
    required this.taskId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'supplier': supplier,
      'price': price,
      'task_id': taskId,
    };
  }

  String toJson() => json.encode(toMap());

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        id: json['id'],
        name: json['name'] as String,
        supplier: json['supplier'] as String,
        price: (json['price'] as num).toDouble(),
        taskId: json['task_id'] as int,
      );

  factory Part.fromMap(Map<String, dynamic> map) => Part.fromJson(map);

  @override
  String toString() {
    return 'Part(id: $id, name: $name, supplier: $supplier, price: $price, taskId: $taskId)';
  }

  // Optional: CopyWith method for easier updates
  Part copyWith({
    int? id,
    String? name,
    String? supplier,
    double? price,
    int? taskId,
  }) {
    return Part(
      id: id ?? this.id,
      name: name ?? this.name,
      supplier: supplier ?? this.supplier,
      price: price ?? this.price,
      taskId: taskId ?? this.taskId,
    );
  }
}