import 'package:flutter/material.dart';
import '../../features/account/presentation/screens/account_screen.dart';
import '../../features/cart/cart_controller.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/favorites/favorite_controller.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/offers/offers_screen.dart';
import '../../features/orders/orders_controller.dart';
import '../theme/app_theme.dart';
import 'floating_bottom_nav.dart';

class ShellScreen extends StatefulWidget {
  final CartController cart;
  final FavoriteController favorites;
  final int initialIndex;

  const ShellScreen({
    super.key,
    required this.cart,
    required this.favorites,
    this.initialIndex = 0,
  });

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen>
    with SingleTickerProviderStateMixin {
  late int _index;
  final ValueNotifier<String?> _homeCategoryFilter = ValueNotifier<String?>(null);
  final OrdersController _orders = OrdersController();
  late AnimationController _transitionController;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fade = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.985, end: 1.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeOutCubic),
    );
    _transitionController.forward();
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _homeCategoryFilter.dispose();
    _orders.dispose();
    super.dispose();
  }

  void _changeTab(int newIndex) {
    if (newIndex == _index) return;
    _transitionController.reset();
    setState(() => _index = newIndex);
    _transitionController.forward();
  }

  void _shopOffer(String categoryId) {
    _homeCategoryFilter.value = categoryId;
    _changeTab(0);
  }

  void _backToHomeFromCart() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    _changeTab(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: IndexedStack(
            index: _index,
            children: [
              HomeScreen(
                cart: widget.cart,
                favorites: widget.favorites,
                orders: _orders,
                externalCategoryFilter: _homeCategoryFilter,
              ),
              OffersScreen(cart: widget.cart, onShopOffer: _shopOffer),
              CartScreen(
                cart: widget.cart,
                orders: _orders,
                embedded: true,
                onBrowseProducts: () => _changeTab(0),
                onBackToHome: _backToHomeFromCart,
              ),
              AccountScreen(
                favorites: widget.favorites,
                cart: widget.cart,
                orders: _orders,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: widget.cart,
        builder: (context, child) => FloatingBottomNav(
          selectedIndex: _index,
          cart: widget.cart,
          onTap: _changeTab,
        ),
      ),
    );
  }
}