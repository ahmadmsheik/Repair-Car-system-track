import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskNavigator extends StatelessWidget {
  const TaskNavigator(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  final IconData icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            FaIcon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: "SF Pro Display",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight),
          ],
        ),
      ),
    );
  }
}
