import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Widgets/task_navigator.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, Colors.grey[800]!.withValues(alpha: .6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const SizedBox(height: 24), _buildMiddleSection()],
      ),
    );
  }

  // Middle Section: Control, Climate, Interior Temperature
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // New Button for Ongoing Tasks Page
              TaskNavigator(
                icon: FontAwesomeIcons.car,
                title: "Cars",
                onTap: () {
                  Get.toNamed('/carsList'); // Navigate to the new page
                },
              ),
              const SizedBox(height: 12),
              // On going tasks
              TaskNavigator(
                icon: FontAwesomeIcons.listCheck,
                title: "Ongoing Tasks",
                onTap: () {
                  Get.toNamed("/typeTask", arguments: "onGoing");
                },
              ),
              const SizedBox(height: 12),
              // Pending tasks
              TaskNavigator(
                icon: FontAwesomeIcons.clock,
                title: "Pending Tasks",
                onTap: () {
                  Get.toNamed("/typeTask", arguments: "pending");
                },
              ),
              const SizedBox(height: 12),
              // Completed tasks
              TaskNavigator(
                icon: FontAwesomeIcons.check,
                title: "Completed Tasks",
                onTap: () {
                  Get.toNamed("/typeTask", arguments: "completed");
                },
              ),
              const SizedBox(height: 12),
              // Clients
              TaskNavigator(
                icon: FontAwesomeIcons.userGroup,
                title: "Clients",
                onTap: () {
                  Get.toNamed("/clientList");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
