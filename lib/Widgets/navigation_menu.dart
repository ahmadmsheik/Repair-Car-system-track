import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import 'package:inter_repair_car/Views/home_view.dart';
import 'package:inter_repair_car/Views/settings_view.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _slectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _slectedIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[const HomeView(), const SettingsView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          (_slectedIndex == 0)
              ? FloatingActionButton(
                onPressed: () {
                  Get.toNamed('/addTaskPage');
                },
                hoverColor: Colors.blueGrey[900],
                backgroundColor: Colors.blueGrey[800],
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(title: const Text('Repair Car Track System')),
      body: _pages[_slectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white, // Color for selected label and icon
        unselectedItemColor: Colors.grey, // Color for unselected label and icon
        selectedIconTheme: IconThemeData(
          color: Colors.white, // Color for selected icon
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey, // Color for unselected icon
        ),
        onTap: _navigateBottomBar,
        currentIndex: _slectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
