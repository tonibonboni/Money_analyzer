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

  // Create from JSON for storage with improved error handling
  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    // Safe date parsing
    DateTime parseDate() {
      try {
        return json['date'] != null 
            ? DateTime.parse(json['date'] as String)
            : DateTime.now();
      } catch (e) {
        print('Error parsing date: $e');
        return DateTime.now();
      }
    }
    
    // Safe price parsing
    double parsePrice() {
      try {
        if (json['price'] == null) return 0.0;
        
        if (json['price'] is int) {
          return (json['price'] as int).toDouble();
        } else if (json['price'] is double) {
          return json['price'] as double;
        } else if (json['price'] is String) {
          return double.tryParse((json['price'] as String).replaceAll(',', '.')) ?? 0.0;
        } else {
          return 0.0;
        }
      } catch (e) {
        print('Error parsing price: $e');
        return 0.0;
      }
    }
    
    return ReceiptItem(
      name: json['name'] as String? ?? 'Unknown item',
      price: parsePrice(),
      currency: json['currency'] as String? ?? '',
      category: json['category'] as String? ?? 'Other',
      date: parseDate(),
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