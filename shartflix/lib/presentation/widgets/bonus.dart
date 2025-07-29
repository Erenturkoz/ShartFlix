import 'package:flutter/material.dart';

class BonusItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const BonusItem({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.pinkAccent, size: 32),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
