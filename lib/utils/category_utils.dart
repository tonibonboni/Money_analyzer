import 'package:flutter/material.dart';

class CategoryUtils {
  // Get list of predefined categories
  static List<String> getPredefinedCategories() {
    return [
      'Food', 
      'Transport', 
      'Entertainment', 
      'Shopping', 
      'Bills', 
      'Other'
    ];
  }
  
  // Get category color
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Transport':
        return Colors.blue;
      case 'Entertainment':
        return Colors.purple;
      case 'Shopping':
        return Colors.teal;
      case 'Bills':
        return Colors.red;
      case 'Other':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
  
  // Get category icon
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Entertainment':
        return Icons.movie;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Bills':
        return Icons.receipt;
      case 'Other':
        return Icons.category;
      default:
        return Icons.category;
    }
  }
} 