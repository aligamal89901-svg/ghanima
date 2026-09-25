import 'package:flutter/material.dart';

class Offer {
  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final int discountPercent;
  final String categoryId;
  final Color colorStart;
  final Color colorEnd;
  final DateTime endAt;

  const Offer({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.discountPercent,
    required this.categoryId,
    required this.colorStart,
    required this.colorEnd,
    required this.endAt,
  });
}