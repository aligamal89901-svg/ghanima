import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../features/cart/cart_controller.dart';
import '../theme/app_theme.dart';

class FloatingTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const FloatingTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class FloatingBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final CartController cart;

  static const List<FloatingTab> tabs = [
    FloatingTab(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'الرئيسية'),
    FloatingTab(icon: Icons.local_offer_outlined, activeIcon: Icons.local_offer, label: 'العروض'),
    FloatingTab(icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart, label: 'السلة'),
    FloatingTab(icon: Icons.person_outline, activeIcon: Icons.person, label: 'الحساب'),
  ];

  const FloatingBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: AppColors.divider),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              tabs.length,
              (index) => _NavItem(
                tab: tabs[index],
                isSelected: index == selectedIndex,
                showBadge: index == 2 && cart.totalCount > 0,
                badgeCount: cart.totalCount,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final FloatingTab tab;
  final bool isSelected;
  final bool showBadge;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isSelected,
    required this.showBadge,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16 : 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? tab.activeIcon : tab.icon,
                    size: 22,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  if (showBadge)
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      top: -6,
                      end: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.surface, width: 2),
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '$badgeCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    tab.label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}