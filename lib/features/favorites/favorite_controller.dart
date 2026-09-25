import 'package:flutter/foundation.dart';
import '../home/data/models/product.dart';

class FavoriteController extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool isFavorite(Product product) => _items.any((p) => p.id == product.id);

  void toggle(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      _items.add(product);
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }
}