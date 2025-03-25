import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Widgets/task_navigator.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand( // Makes container fill entire screen
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[900]!, Colors.grey[800]!.withValues(alpha: .6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: .2),
              width: 2,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildMiddleSection(),
                // Add bottom spacer to prevent cutoff
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey[800]!, Colors.blueGrey[900]!],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TaskNavigator(
              icon: FontAwesomeIcons.car,
              title: "Cars",
              onTap: () => Get.toNamed('/carsList'),
            ),
            const SizedBox(height: 12),
            TaskNavigator(
              icon: FontAwesomeIcons.listCheck,
              title: "Ongoing Tasks",
              onTap: () => Get.toNamed("/typeTask", arguments: "onGoing"),
            ),
            const SizedBox(height: 12),
            TaskNavigator(
              icon: FontAwesomeIcons.clock,
              title: "Pending Tasks",
              onTap: () => Get.toNamed("/typeTask", arguments: "pending"),
            ),
            const SizedBox(height: 12),
            TaskNavigator(
              icon: FontAwesomeIcons.check,
              title: "Completed Tasks",
              onTap: () => Get.toNamed("/typeTask", arguments: "completed"),
            ),
            const SizedBox(height: 12),
            TaskNavigator(
              icon: FontAwesomeIcons.userGroup,
              title: "Clients",
              onTap: () => Get.toNamed("/clientList"),
            ),
          ],
        ),
      ),
    );
  }
}