import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/expenditure_contorller.dart';
import 'package:inter_repair_car/Models/Entities/Expenditure.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';
import 'package:inter_repair_car/Widgets/expenditure_card.dart';
import 'package:inter_repair_car/Widgets/add_expenditure_sheet.dart';

class ExpendituresPage extends StatefulWidget {
  const ExpendituresPage({Key? key}) : super(key: key);

  @override
  _ExpendituresPageState createState() => _ExpendituresPageState();
}

class _ExpendituresPageState extends State<ExpendituresPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ExpenditureController _expenditureController = Get.put(
    ExpenditureController(),
  );
  List<Expenditure> _expenditures = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenditures();
  }

  Future<void> _loadExpenditures() async {
    setState(() {
      _isLoading = true;
    });
    final expenditures = await _dbHelper.getExpenditures();
    setState(() {
      _expenditures = expenditures;
      _isLoading = false;
    });
  }

  void _showAddExpenditureSheet() {
    _expenditureController.clearForm(); // Clear form for new entry
    Get.bottomSheet(
      AddExpenditureSheet(
        onSave: (newExpenditure) async {
          await _dbHelper.insertExpenditure(newExpenditure);
          _loadExpenditures();
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showEditExpenditureSheet(Expenditure expenditure) {
    _expenditureController.initExpenditure(
      expenditure,
    ); // Initialize with existing data
    Get.bottomSheet(
      AddExpenditureSheet(
        onSave: (updatedExpenditure) async {
          await _dbHelper.updateExpenditure(updatedExpenditure);
          _loadExpenditures();
        },
        existingExpenditure: expenditure,
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _deleteExpenditure(int id) async {
    final shouldDelete = await Get.dialog(
      AlertDialog(
        title: const Text('Delete Expenditure'),
        content: const Text(
          'Are you sure you want to delete this expenditure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _dbHelper.deleteExpenditure(id);
      _loadExpenditures();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenditures')),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : _expenditures.isEmpty
              ? const Center(child: Text('No expenditures found'))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                itemCount: _expenditures.length,
                itemBuilder: (context, index) {
                  final expenditure = _expenditures[index];
                  return ExpenditureCard(
                    expenditure: expenditure,
                    onDelete: () => _deleteExpenditure(expenditure.id!),
                    onUpdate: () => _showEditExpenditureSheet(expenditure),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        onPressed: _showAddExpenditureSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
