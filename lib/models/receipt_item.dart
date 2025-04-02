import 'package:flutter/material.dart';

class ReceiptItem {
  final String name;
  final double price;
  final String currency;
  final String category;
  final DateTime dateAdded;
  final String receiptId;

  ReceiptItem({
    required this.name,
    required this.price,
    required this.currency,
    required this.category,
    required this.dateAdded,
    required this.receiptId,
  });

  // Create from JSON for database storage
  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      name: json['name'],
      price: json['price'],
      currency: json['currency'],
      category: json['category'],
      dateAdded: DateTime.parse(json['dateAdded']),
      receiptId: json['receiptId'],
    );
  }

  // Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'currency': currency,
      'category': category,
      'dateAdded': dateAdded.toIso8601String(),
      'receiptId': receiptId,
    };
  }
} 