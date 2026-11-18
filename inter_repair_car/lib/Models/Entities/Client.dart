import 'dart:convert';

class Client {
  const Client({this.id, required this.name, required this.phone});

  final int? id;
  final String name;
  final int phone;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone};
  }

  String toJson() => json.encode(toMap());

  factory Client.fromJson(Map<String, dynamic> json) =>
      Client(id: json['id'], name: json['name'], phone: int.parse(json['phone']));

  factory Client.fromMap(Map<String, dynamic> map) => Client.fromJson(map);
}
