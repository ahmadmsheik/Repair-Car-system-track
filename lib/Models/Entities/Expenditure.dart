class Expenditure {
  final int? id;
  final String name;
  final String expenseType;
  final double amount;
  final DateTime? dueDate;
  final String? description;

  Expenditure({
    this.id,
    required this.name,
    required this.expenseType,
    required this.amount,
    this.dueDate,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'expense_type': expenseType,
      'amount': amount,
      'due_date': dueDate?.toIso8601String(),
      'description': description,
    };
  }

  factory Expenditure.fromMap(Map<String, dynamic> map) {
    return Expenditure(
      id: map['id'],
      name: map['name'],
      expenseType: map['expense_type'],
      amount: map['amount'],
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      description: map['description'],
    );
  }

  factory Expenditure.fromJson(Map<String, dynamic> json) {
    return Expenditure(
      id: json['id'],
      name: json['name'],
      expenseType: json['expense_type'],
      amount:
          json['amount'] is int
              ? (json['amount'] as int)
                  .toDouble() // Handle integer values
              : json['amount'],
      dueDate:
          json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      description: json['description'],
    );
  }
}
