import 'package:flutter/foundation.dart';
import '../cart/cart_controller.dart';
import 'data/models/order_model.dart';

class OrdersController extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  int get count => _orders.length;

  OrderModel placeOrder({
    required List<CartItem> items,
    required double total,
  }) {
    final order = OrderModel(
      id: 'G-${DateTime.now().millisecondsSinceEpoch % 100000}',
      items: [
        for (final item in items)
          OrderItem(product: item.product, quantity: item.quantity),
      ],
      total: total,
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }

  void cancelOrder(String orderId) {
    final order = _orders.where((o) => o.id == orderId).firstOrNull;
    if (order == null || !order.cancellable) return;
    order.status = OrderStatus.cancelled;
    notifyListeners();
  }
}