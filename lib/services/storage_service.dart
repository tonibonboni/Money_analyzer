import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/receipt_item.dart';

class StorageService {
  static const String _storageKey = 'receipt_items';

  // Save a list of receipt items with error handling
  Future<void> saveReceiptItems(List<ReceiptItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing items
      List<ReceiptItem> existingItems = await getReceiptItems();
      
      // Add new items
      existingItems.addAll(items);
      
      // Convert to JSON with error handling
      List<String> jsonItems = [];
      for (var item in existingItems) {
        try {
          jsonItems.add(jsonEncode(item.toJson()));
        } catch (e) {
          print('Error encoding item: $e');
          // Skip invalid items
        }
      }
      
      // Save
      await prefs.setStringList(_storageKey, jsonItems);
    } catch (e) {
      print('Error saving receipt items: $e');
      throw Exception('Failed to save items: $e');
    }
  }

  // Get all receipt items with error handling
  Future<List<ReceiptItem>> getReceiptItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonItems = prefs.getStringList(_storageKey) ?? [];
      
      List<ReceiptItem> items = [];
      for (var jsonItem in jsonItems) {
        try {
          items.add(ReceiptItem.fromJson(jsonDecode(jsonItem)));
        } catch (e) {
          print('Error decoding item: $e');
          // Skip invalid items
        }
      }
      
      return items;
    } catch (e) {
      print('Error retrieving receipt items: $e');
      return []; // Return empty list on error
    }
  }

  // Get items by category with error handling
  Future<List<ReceiptItem>> getItemsByCategory(String category) async {
    try {
      List<ReceiptItem> allItems = await getReceiptItems();
      return allItems.where((item) => item.category == category).toList();
    } catch (e) {
      print('Error retrieving items by category: $e');
      return []; // Return empty list on error
    }
  }

  // Get items sorted by date (newest first)
  List<ReceiptItem> sortItemsByDate(List<ReceiptItem> items) {
    try {
      items.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      print('Error sorting items by date: $e');
      // Leave items unsorted in case of error
    }
    return items;
  }
  
  // Get items for a specific month and year with error handling
  Future<List<ReceiptItem>> getItemsByMonth(String category, int month, int year) async {
    try {
      List<ReceiptItem> categoryItems = await getItemsByCategory(category);
      
      return categoryItems.where((item) => 
        item.date.month == month && item.date.year == year).toList();
    } catch (e) {
      print('Error retrieving items by month: $e');
      return []; // Return empty list on error
    }
  }
  
  // Delete an item with error handling
  Future<void> deleteItem(ReceiptItem itemToDelete) async {
    try {
      List<ReceiptItem> allItems = await getReceiptItems();
      
      allItems.removeWhere((item) => 
        item.name == itemToDelete.name && 
        item.price == itemToDelete.price && 
        item.date.isAtSameMomentAs(itemToDelete.date));
      
      // Convert to JSON with error handling
      List<String> jsonItems = [];
      for (var item in allItems) {
        try {
          jsonItems.add(jsonEncode(item.toJson()));
        } catch (e) {
          print('Error encoding item during deletion: $e');
          // Skip invalid items
        }
      }
      
      // Save
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, jsonItems);
    } catch (e) {
      print('Error deleting item: $e');
      throw Exception('Failed to delete item: $e');
    }
  }
} 