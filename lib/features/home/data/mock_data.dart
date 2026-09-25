import 'package:flutter/material.dart';
import 'models/category.dart';
import 'models/offer.dart';
import 'models/product.dart';

class MockData {
  static const List<Category> categories = [
    Category(id: 'veg', name: 'خضار وفواكه', icon: Icons.eco_outlined, color: Color(0xFFFCE4EC)),
    Category(id: 'bakery', name: 'مخبوزات', icon: Icons.bakery_dining_outlined, color: Color(0xFFF7EBDD)),
    Category(id: 'drinks', name: 'مشروبات', icon: Icons.local_drink_outlined, color: Color(0xFFE3F0F5)),
    Category(id: 'dairy', name: 'ألبان وأجبان', icon: Icons.breakfast_dining_outlined, color: Color(0xFFFDF6E3)),
    Category(id: 'cleaning', name: 'منظفات', icon: Icons.cleaning_services_outlined, color: Color(0xFFEDEBF7)),
  ];

  static const List<Product> products = [
    Product(id: 'p1', name: 'طماطم طازجة', price: 6.5, unit: 'لكل كجم', categoryId: 'veg'),
    Product(id: 'p4', name: 'خبز بر عربي', price: 2.5, unit: 'ربطة', categoryId: 'bakery'),
  ];

  static const List<Offer> offers = [
    Offer(id: 'o1', title: 'عرض الأسبوع', subtitle: 'خضار اليوم بأسعار مخفضة', badge: 'خصم 20%'),
    Offer(id: 'o2', title: 'خبز طازج', subtitle: 'اشترِ ربطتين والثالثة هدية', badge: '2+1'),
    Offer(id: 'o3', title: 'ركن الألبان', subtitle: 'أسعار خاصة على الأجبان', badge: 'خصم 15%'),
  ];
}