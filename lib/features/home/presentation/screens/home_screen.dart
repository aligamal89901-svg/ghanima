import 'package:flutter/material.dart';
import '../../../../core/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/cart_controller.dart';
import '../../../splash/presentation/screens/placeholder_screen.dart';
import '../../data/home_repository.dart';
import '../../data/models/category.dart';
import '../../data/models/offer.dart';
import '../../data/models/product.dart';
import '../widgets/cart_bottom_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/offer_card.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  final CartController cart;

  const HomeScreen({super.key, required this.cart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeRepository _repository = MockHomeRepository();
  final TextEditingController _searchController = TextEditingController();

  late final List<Category> _categories;
  late final List<Product> _products;
  late final List<Offer> _offers;

  String? _selectedCategoryId;
  String _searchQuery = '';

  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _categories = _repository.getCategories();
    _products = _repository.getProducts();
    _offers = _repository.getOffers();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategoryId == null ||
          product.categoryId == _selectedCategoryId;
      final matchesSearch =
          _searchQuery.isEmpty || product.name.contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Animation<double> _section(double start, double end) {
    return CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  Widget _fadeSlide(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _fadeSlide(_section(0.0, 0.4), _buildHeader()),
                _fadeSlide(_section(0.1, 0.5), _buildSearch()),
                _fadeSlide(_section(0.2, 0.6), _buildOffers()),
                _fadeSlide(_section(0.3, 0.7), _buildChips()),
                Expanded(child: _fadeSlide(_section(0.4, 0.9), _buildGrid(filtered))),
              ],
            ),
            _buildCartBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  AppConstants.storeName,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  AppConstants.storeTagline,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ListenableBuilder(
            listenable: widget.cart,
            builder: (context, child) {
              final count = widget.cart.totalCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  if (count > 0)
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      top: -4,
                      end: -4,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Container(
                          key: ValueKey(count),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value.trim()),
        decoration: const InputDecoration(
          hintText: 'ابحث عن منتج...',
          hintStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 22),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildOffers() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        children: _offers.map((offer) => OfferCard(offer: offer)).toList(),
      ),
    );
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
      child: CategoryChips(
        categories: _categories,
        selectedCategoryId: _selectedCategoryId,
        onSelected: (id) => setState(() => _selectedCategoryId = id),
      ),
    );
  }

  Widget _buildGrid(List<Product> filtered) {
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'ما لقينا نتائج مطابقة',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'جرّب كلمة أخرى أو غيّر الصنف',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final categoryById = {for (final category in _categories) category.id: category};

    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 96),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final product = filtered[index];
        return ProductCard(
          product: product,
          category: categoryById[product.categoryId]!,
          cart: widget.cart,
        );
      },
    );
  }

  Widget _buildCartBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ListenableBuilder(
        listenable: widget.cart,
        builder: (context, child) {
          final isEmpty = widget.cart.isEmpty;
          return IgnorePointer(
            ignoring: isEmpty,
            child: AnimatedSlide(
              offset: isEmpty ? const Offset(0, 1.5) : Offset.zero,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: isEmpty ? 0 : 1,
                duration: const Duration(milliseconds: 250),
                child: CartBottomBar(
                  cart: widget.cart,
                  onViewCart: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PlaceholderScreen(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}