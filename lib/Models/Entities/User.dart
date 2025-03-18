import 'dart:convert';

class User {
  const User({this.id, required this.name, required this.phone});

  final int? id;
  final String name;
  final int phone;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone};
  }

  String toJson() => json.encode(toMap());
}
