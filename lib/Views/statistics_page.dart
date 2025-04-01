// views/statistics_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/statistics_controller.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsPage extends StatelessWidget {
  final StatisticsController _controller = Get.put(StatisticsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repair Shop Statistics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _controller.loadAllStatistics,
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.monthlyRevenue.isEmpty ||
            _controller.taskStatusDistribution.isEmpty) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSummaryCards(),
              SizedBox(height: 24),
              _buildMonthlyRevenueChart(),
              SizedBox(height: 24),
              _buildTaskStatusChart(),
              SizedBox(height: 24),
              _buildVehicleMakeChart(),
              SizedBox(height: 24),
              _buildPartsCostChart(),
              SizedBox(height: 24),
              _buildExpenditureChart(), // Add this line
              SizedBox(height: 24),
              _buildExpenditureByTypeChart(), // Add this line
            ],
          ),
        );
      }),
    );
  }

  Widget _buildExpenditureChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Expenditure',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.currency(symbol: '\$'),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<ChartData, String>(
                    dataSource: _controller.expenditureData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Colors.red[400],
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.outer,
                      textStyle: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenditureByTypeChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenditure by Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: _controller.expenditureByType,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                    explode: true,
                    explodeIndex: 0,
                    explodeOffset: '10%',
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => _buildSummaryCard(
              'Monthly Revenue',
              '\$${_controller.currentMonthRevenue.value.toStringAsFixed(2)}',
              Colors.blue,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Obx(
            () => _buildSummaryCard(
              'Completed Tasks',
              _controller.completedTasksCount.value.toString(),
              Colors.green,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Obx(
            () => _buildSummaryCard(
              'Total Vehicles',
              _controller.totalVehiclesCount.value.toString(),
              Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      color: color,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyRevenueChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Revenue by Week',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<ChartData, String>(
                    dataSource: _controller.monthlyRevenue,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Colors.blue,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatusChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Status Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: SfCircularChart(
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: _controller.taskStatusDistribution,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleMakeChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Makes in Shop',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  BarSeries<ChartData, String>(
                    dataSource: _controller.vehicleMakeDistribution,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Colors.green,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartsCostChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parts Cost by Supplier',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  LineSeries<ChartData, String>(
                    dataSource: _controller.partsCostDistribution,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    markerSettings: MarkerSettings(isVisible: true),
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
