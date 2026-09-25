import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../cart/cart_controller.dart';
import '../../../data/home_repository.dart';
import '../../widgets/offer_card.dart';

class OffersScreen extends StatelessWidget {
  final CartController cart;
  final ValueChanged<String> onShopOffer;

  const OffersScreen({
    super.key,
    required this.cart,
    required this.onShopOffer,
  });

  @override
  Widget build(BuildContext context) {
    final repository = MockHomeRepository();
    final offers = repository.getOffers();
    final categories = repository.getCategories();
    final categoryById = {for (final category in categories) category.id: category};

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            const Text(
              'عروض اليوم',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'خصومات حصرية تنتهي قريبًا — اغتنمها قبل فوات الأوان.',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            for (final offer in offers)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SizedBox(
                  height: 268,
                  child: OfferCard(
                    offer: offer,
                    category: categoryById[offer.categoryId],
                    onShopTap: () => onShopOffer(offer.categoryId),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}