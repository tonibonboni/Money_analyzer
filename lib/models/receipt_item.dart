import 'package:flutter/material.dart';

class ReceiptItem {
  final String name;
  final double price;
  final String currency;
  final String category;
  final DateTime date;

  ReceiptItem({
    required this.name,
    required this.price,
    required this.currency,
    required this.category,
    required this.date,
  });

  // Create from JSON for storage
  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      name: json['name'] ?? '',
      price: json['price'] != null ? (json['price'] is int ? (json['price'] as int).toDouble() : json['price'] as double) : 0.0,
      currency: json['currency'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'currency': currency,
      'category': category,
      'date': date.toIso8601String(),
    };
  }
} 