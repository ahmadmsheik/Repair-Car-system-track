import 'package:flutter/material.dart';
import 'package:inter_repair_car/Models/Entities/Expenditure.dart';

class ExpenditureCard extends StatelessWidget {
  final Expenditure expenditure;
  final Function onDelete;
  final Function onUpdate;

  const ExpenditureCard({
    Key? key,
    required this.expenditure,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expenditure.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => onUpdate(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Type: ${expenditure.expenseType}'),
            Text('Amount: \$${expenditure.amount.toStringAsFixed(2)}'),
            if (expenditure.dueDate != null)
              Text('Due: ${_formatDate(expenditure.dueDate!)}'),
            if (expenditure.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  expenditure.description!,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
