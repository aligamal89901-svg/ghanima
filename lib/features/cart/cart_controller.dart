import 'package:flutter/foundation.dart';
import '../home/data/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  int quantityOf(Product product) {
    final item = _items.where((i) => i.product.id == product.id).firstOrNull;
    return item?.quantity ?? 0;
  }

  void add(Product product) {
    final item = _items.where((i) => i.product.id == product.id).firstOrNull;
    if (item == null) {
      _items.add(CartItem(product: product));
    } else {
      item.quantity += 1;
    }
    notifyListeners();
  }

  void decrease(Product product) {
    final item = _items.where((i) => i.product.id == product.id).firstOrNull;
    if (item == null) return;
    if (item.quantity <= 1) {
      _items.remove(item);
    } else {
      item.quantity -= 1;
    }
    notifyListeners();
  }
}