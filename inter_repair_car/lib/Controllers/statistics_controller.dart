// controllers/statistics_controller.dart
import 'package:get/get.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';
import 'package:intl/intl.dart';

class StatisticsController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Observable lists for charts
  final monthlyRevenue = <ChartData>[].obs;
  final taskStatusDistribution = <ChartData>[].obs;
  final vehicleMakeDistribution = <ChartData>[].obs;
  final partsCostDistribution = <ChartData>[].obs;

  final expenditureData = <ChartData>[].obs;
  final expenditureByType = <ChartData>[].obs;

  // Observable values for summary cards
  final currentMonthRevenue = 0.0.obs;
  final completedTasksCount = 0.obs;
  final totalVehiclesCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllStatistics();
  }

  Future<void> loadAllStatistics() async {
    await Future.wait([
      loadMonthlyRevenue(),
      loadTaskStatusDistribution(),
      loadVehicleMakeDistribution(),
      loadPartsCostDistribution(),
      loadSummaryData(),
      loadExpenditureData(), // Add this line
    ]);
  }

  Future<void> loadExpenditureData() async {
    final expenditures = await _dbHelper.getExpenditures();

    // Total expenditure by month
    final monthlyExpenditure = <String, double>{};
    final expenditureTypes = <String, double>{};

    for (final exp in expenditures) {
      DateTime dueDate;
      try {
        dueDate = DateTime.parse(
          exp.dueDate?.toString() ?? DateTime.now().toString(),
        );
      } catch (e) {
        dueDate = DateTime.now();
      }

      final month = DateFormat('MMM yyyy').format(dueDate);
      monthlyExpenditure[month] = (monthlyExpenditure[month] ?? 0) + exp.amount;

      // Ensure expenseType is treated as String
      final type = exp.expenseType.toString();
      expenditureTypes[type] = (expenditureTypes[type] ?? 0) + exp.amount;
    }

    expenditureData.value =
        monthlyExpenditure.entries
            .map((e) => ChartData(e.key, e.value))
            .toList();

    expenditureByType.value =
        expenditureTypes.entries.map((e) => ChartData(e.key, e.value)).toList();
  }

  Future<void> loadSummaryData() async {
    final now = DateTime.now();
    final tasks = await _dbHelper.getTasksByStatus('completed');

    currentMonthRevenue.value = tasks
        .where((task) {
          return task.timeEnd != null &&
              task.timeEnd!.month == now.month &&
              task.timeEnd!.year == now.year;
        })
        .fold(0.0, (sum, task) => sum + task.cost);

    completedTasksCount.value = await _dbHelper.countCompletedTasks();

    final vehicles = await _dbHelper.getVehicles();
    totalVehiclesCount.value = vehicles.length;
  }

  Future<void> loadMonthlyRevenue() async {
    final now = DateTime.now();
    final tasks = await _dbHelper.getTasksByStatus('completed');
    final weeklyRevenue = <int, double>{};

    for (final task in tasks.where(
      (t) =>
          t.timeEnd != null &&
          t.timeEnd!.month == now.month &&
          t.timeEnd!.year == now.year,
    )) {
      final weekNumber = ((task.timeEnd!.day - 1) ~/ 7) + 1;
      weeklyRevenue[weekNumber] = (weeklyRevenue[weekNumber] ?? 0) + task.cost;
    }

    monthlyRevenue.value =
        weeklyRevenue.entries
            .map((e) => ChartData('Week ${e.key}', e.value))
            .toList();
  }

  Future<void> loadTaskStatusDistribution() async {
    final tasks = await _dbHelper.getTasks();
    final statusCounts = <String, int>{};

    for (final task in tasks) {
      statusCounts[task.status] = (statusCounts[task.status] ?? 0) + 1;
    }

    taskStatusDistribution.value =
        statusCounts.entries
            .map((e) => ChartData(e.key, e.value.toDouble()))
            .toList();
  }

  Future<void> loadVehicleMakeDistribution() async {
    final vehicles = await _dbHelper.getVehicles();
    final makeCounts = <String, int>{};

    for (final vehicle in vehicles) {
      makeCounts[vehicle.make] = (makeCounts[vehicle.make] ?? 0) + 1;
    }

    vehicleMakeDistribution.value =
        makeCounts.entries
            .map((e) => ChartData(e.key, e.value.toDouble()))
            .toList();
  }

  Future<void> loadPartsCostDistribution() async {
    final parts = await _dbHelper.getAllParts();
    final supplierCosts = <String, double>{};

    for (final part in parts) {
      final supplier = part['supplier'] as String;
      final price = part['price'] as double;
      supplierCosts[supplier] = (supplierCosts[supplier] ?? 0) + price;
    }

    partsCostDistribution.value =
        supplierCosts.entries.map((e) => ChartData(e.key, e.value)).toList();
  }

  Future<double> getCurrentMonthRevenue() async {
    final now = DateTime.now();
    final tasks = await _dbHelper.getTasksByStatus('completed');
    final thisMonthTasks =
        tasks.where((task) {
          return task.timeEnd != null &&
              task.timeEnd!.month == now.month &&
              task.timeEnd!.year == now.year;
        }).toList();

    return thisMonthTasks.fold(
      0.0,
      (sum, task) async => await sum + (task.cost),
    );
  }

  Future<int> getCompletedTasksCount() async {
    return await _dbHelper.countCompletedTasks();
  }

  Future<int> getTotalVehiclesCount() async {
    final vehicles = await _dbHelper.getVehicles();
    return vehicles.length;
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
