import 'package:flutter/material.dart';
import 'package:shartflix/presentation/widgets/bonus.dart';
import 'package:shartflix/presentation/widgets/jeton_card.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gri bar
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const Text(
                  "Sınırlı Teklif",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Jeton paketini seçerek bonus kazan\nve yeni bölümlerin kilidini aç!",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Bonuslar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    BonusItem(icon: Icons.diamond, label: "Premium"),
                    BonusItem(icon: Icons.favorite, label: "Eşleşme"),
                    BonusItem(icon: Icons.trending_up, label: "Öne Çıkarma"),
                    BonusItem(icon: Icons.thumb_up, label: "Beğeni"),
                  ],
                ),

                const SizedBox(height: 24),

                // Jeton paketleri
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    JetonPackageCard(
                      percent: "+10%",
                      coins: "330",
                      oldCoins: "200",
                      price: "₺99,99",
                    ),
                    JetonPackageCard(
                      percent: "+70%",
                      coins: "3.375",
                      oldCoins: "2.000",
                      price: "₺799,99",
                      isMain: true,
                    ),
                    JetonPackageCard(
                      percent: "+35%",
                      coins: "1.350",
                      oldCoins: "1.000",
                      price: "₺399,99",
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Tüm Jetonları Gör",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
