import 'package:flutter/material.dart';

class JetonPackageCard extends StatelessWidget {
  final String percent;
  final String coins;
  final String oldCoins;
  final String price;
  final bool isMain;

  const JetonPackageCard({
    super.key,
    required this.percent,
    required this.coins,
    required this.oldCoins,
    required this.price,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMain ? Colors.purple : Colors.red.shade900,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              percent,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              coins + " Jeton",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              "Eskiden: $oldCoins",
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(color: Colors.white)),
            const Text(
              "Başına haftalık",
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
