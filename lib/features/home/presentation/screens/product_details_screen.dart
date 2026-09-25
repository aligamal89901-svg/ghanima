import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/cart_controller.dart';
import '../../../favorites/favorite_controller.dart';
import '../../data/models/category.dart';
import '../../data/models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final Category category;
  final CartController cart;
  final FavoriteController favorites;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.category,
    required this.cart,
    required this.favorites,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  int _quantity = 1;
  bool _justAdded = false;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _entranceController.dispose();
    super.dispose();
  }

  void _addToCart() {
    widget.cart.addQuantity(widget.product, _quantity);
    setState(() {
      _justAdded = true;
      _quantity = 1;
    });
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _justAdded = false);
      }
    });
  }

  Animation<double> _phase(double start, double end) {
    return CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inCart = widget.cart.quantityOf(widget.product);
    final total = widget.product.price * _quantity;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHero(),
                    const SizedBox(height: 20),
                    _buildInfo(),
                    if (inCart > 0) ...[
                      const SizedBox(height: 16),
                      _buildInCartNote(inCart),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomBar(total),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 16, 8),
      child: Row(
        children: [
          const BackButton(color: AppColors.primary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              widget.category.name,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    final animation = _phase(0.0, 0.6);
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.94, end: 1.0).animate(animation),
        child: Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.category.color,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(widget.category.icon, size: 84, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    final animation = _phase(0.25, 0.8);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
                .animate(animation),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
                ListenableBuilder(
                  listenable: widget.favorites,
                  builder: (context, child) {
                    final isFavorite = widget.favorites.isFavorite(widget.product);
                    return GestureDetector(
                      onTap: () => widget.favorites.toggle(widget.product),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 24,
                          color: isFavorite
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.product.unit,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: widget.product.price.toStringAsFixed(2),
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                children: [
                  TextSpan(
                    text: ' ${AppConstants.currency}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.description,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 15,
                height: 1.7,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInCartNote(int count) {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          'لديك $count من هذا المنتج في السلة',
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStepper(),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: GestureDetector(
                key: ValueKey(_justAdded),
                onTap: _justAdded ? null : _addToCart,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color:
                        _justAdded ? AppColors.primaryDark : AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _justAdded
                        ? 'تمت الإضافة ✓'
                        : 'أضف للسلة • ${total.toStringAsFixed(2)} ${AppConstants.currency}',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: _quantity > 1 ? () => setState(() => _quantity -= 1) : null,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$_quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: () => setState(() => _quantity += 1),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 52,
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? AppColors.divider : AppColors.primary,
        ),
      ),
    );
  }
}