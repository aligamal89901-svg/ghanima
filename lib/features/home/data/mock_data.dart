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
    Product(
      id: 'p1',
      name: 'طماطم طازجة',
      price: 6.5,
      unit: 'لكل كجم',
      categoryId: 'veg',
      description: 'طماطم بلدية طازجة تصل يوميًا، متماسكة ومناسبة للسلطات والطبخ.',
    ),
    Product(
      id: 'p4',
      name: 'خبز بر عربي',
      price: 2.5,
      unit: 'ربطة',
      categoryId: 'bakery',
      description: 'خبز بر طازج يُخبز عدة مرات يوميًا، طري ومناسب للفطور والعشاء.',
    ),
  ];

  static final List<Offer> offers = [
    Offer(
      id: 'o1',
      title: 'عرض اليوم: الألبان',
      subtitle: 'خصم 20% على جميع الألبان الطازجة حتى إغلاق الفترة المسائية.',
      badge: 'عرض اليوم',
      discountPercent: 20,
      categoryId: 'dairy',
      colorStart: Color(0xFF2E9E63),
      colorEnd: Color(0xFF1E6E42),
      endAt: DateTime.now().add(const Duration(hours: 8)),
    ),
    Offer(
      id: 'o2',
      title: 'الساعة الذهبية للمخبوزات',
      subtitle: 'خصم 25% على كل المخبوزات — لساعات محدودة فقط اليوم.',
      badge: 'عرض قوي',
      discountPercent: 25,
      categoryId: 'bakery',
      colorStart: Color(0xFFE8833A),
      colorEnd: Color(0xFFC2571B),
      endAt: DateTime.now().add(const Duration(hours: 1, minutes: 58)),
    ),
    Offer(
      id: 'o3',
      title: 'خضار الأسبوع',
      subtitle: 'أسعار مخفضة على خضار اليوم المختارة حتى نفاد الكمية.',
      badge: 'ينتهي قريبًا',
      discountPercent: 15,
      categoryId: 'veg',
      colorStart: Color(0xFFC2185B),
      colorEnd: Color(0xFF8E1043),
      endAt: DateTime.now().add(const Duration(hours: 25)),
    ),
  ];
}