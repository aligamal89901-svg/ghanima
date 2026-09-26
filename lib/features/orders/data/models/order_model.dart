import 'package:flutter/material.dart';
import '../../../home/data/models/product.dart';

enum OrderStatus { received, reviewing, preparing, ready, completed, cancelled }

class OrderItem {
  final Product product;
  final int quantity;

  const OrderItem({required this.product, required this.quantity});
}

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final double total;
  final DateTime createdAt;
  OrderStatus status;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    this.status = OrderStatus.received,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get cancellable =>
      status == OrderStatus.received ||
      status == OrderStatus.reviewing ||
      status == OrderStatus.preparing;
}

String orderStatusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.received:
      return 'تم الاستلام';
    case OrderStatus.reviewing:
      return 'قيد المراجعة';
    case OrderStatus.preparing:
      return 'جاري التجهيز';
    case OrderStatus.ready:
      return 'جاهز للاستلام';
    case OrderStatus.completed:
      return 'مكتمل';
    case OrderStatus.cancelled:
      return 'ملغي';
  }
}

Color orderStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.received:
      return const Color(0xFF2E9E63);
    case OrderStatus.reviewing:
      return const Color(0xFFE8833A);
    case OrderStatus.preparing:
      return const Color(0xFFC2185B);
    case OrderStatus.ready:
      return const Color(0xFF1E6E42);
    case OrderStatus.completed:
      return const Color(0xFF6B7280);
    case OrderStatus.cancelled:
      return const Color(0xFFD32F2F);
  }
}