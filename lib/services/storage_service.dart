import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/receipt_item.dart';

class StorageService {
  static const String _storageKey = 'receipt_items';

  // Save a list of receipt items
  Future<void> saveReceiptItems(List<ReceiptItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing items
    List<ReceiptItem> existingItems = await getReceiptItems();
    
    // Add new items
    existingItems.addAll(items);
    
    // Convert to JSON
    List<String> jsonItems = existingItems.map((item) => jsonEncode(item.toJson())).toList();
    
    // Save
    await prefs.setStringList(_storageKey, jsonItems);
  }

  // Get all receipt items
  Future<List<ReceiptItem>> getReceiptItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonItems = prefs.getStringList(_storageKey) ?? [];
    
    return jsonItems
        .map((jsonItem) => ReceiptItem.fromJson(jsonDecode(jsonItem)))
        .toList();
  }

  // Get items by category
  Future<List<ReceiptItem>> getItemsByCategory(String category) async {
    List<ReceiptItem> allItems = await getReceiptItems();
    return allItems.where((item) => item.category == category).toList();
  }

  // Get items sorted by date (newest first)
  List<ReceiptItem> sortItemsByDate(List<ReceiptItem> items) {
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }
  
  // Get items for a specific month and year
  Future<List<ReceiptItem>> getItemsByMonth(String category, int month, int year) async {
    List<ReceiptItem> categoryItems = await getItemsByCategory(category);
    
    return categoryItems.where((item) => 
      item.date.month == month && item.date.year == year).toList();
  }
  
  // Delete an item
  Future<void> deleteItem(ReceiptItem itemToDelete) async {
    List<ReceiptItem> allItems = await getReceiptItems();
    
    allItems.removeWhere((item) => 
      item.name == itemToDelete.name && 
      item.price == itemToDelete.price && 
      item.date.isAtSameMomentAs(itemToDelete.date));
    
    // Convert to JSON
    List<String> jsonItems = allItems.map((item) => jsonEncode(item.toJson())).toList();
    
    // Save
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, jsonItems);
  }
} 