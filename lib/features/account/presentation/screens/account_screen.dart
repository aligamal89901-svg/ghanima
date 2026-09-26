import 'package:flutter/material.dart';
import '../../../../core/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/cart_controller.dart';
import '../../../favorites/favorite_controller.dart';
import '../../../favorites/presentation/screens/favorites_screen.dart';
import '../../../orders/orders_controller.dart';
import '../../../orders/presentation/screens/orders_screen.dart';
import '../../../store_info/presentation/screens/store_info_screen.dart';

class AccountScreen extends StatelessWidget {
  final FavoriteController favorites;
  final CartController cart;
  final OrdersController orders;

  const AccountScreen({
    super.key,
    required this.favorites,
    required this.cart,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'حسابي',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحبًا بك في ضيافتنا',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'تسوّق كضيف · سجل لاحقًا لحفظ طلباتك',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListenableBuilder(
                listenable: orders,
                builder: (context, child) => _MenuTile(
                  icon: Icons.receipt_long_outlined,
                  label: 'طلباتي',
                  note: orders.count > 0 ? '${orders.count}' : null,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrdersScreen(orders: orders),
                    ),
                  ),
                ),
              ),
              ListenableBuilder(
                listenable: favorites,
                builder: (context, child) => _MenuTile(
                  icon: Icons.favorite_outline,
                  label: 'المفضلة',
                  note: favorites.count > 0 ? '${favorites.count}' : null,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FavoritesScreen(
                        favorites: favorites,
                        cart: cart,
                      ),
                    ),
                  ),
                ),
              ),
              _MenuTile(
                icon: Icons.storefront_outlined,
                label: 'معلومات المتجر',
                note: 'القطن',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StoreInfoScreen(),
                  ),
                ),
              ),
              const _MenuTile(
                icon: Icons.language_outlined,
                label: 'اللغة',
                note: 'العربية',
              ),
              const _MenuTile(icon: Icons.help_outline, label: 'المساعدة والدعم'),
              _MenuTile(
                icon: Icons.info_outline,
                label: 'عن التطبيق',
                note: 'v${AppConstants.appVersion}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? note;
  final VoidCallback? onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    this.note,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (note != null)
              Text(
                note!,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_left, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}