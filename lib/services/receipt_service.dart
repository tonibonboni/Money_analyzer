import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/receipt_item.dart';

class ReceiptService {
  static const String _storageKey = 'receipt_items';
  
  // Save a list of receipt items
  Future<bool> saveReceiptItems(List<ReceiptItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingItemsJson = prefs.getStringList(_storageKey) ?? [];
      final existingItems = existingItemsJson
          .map((jsonStr) => ReceiptItem.fromJson(jsonDecode(jsonStr)))
          .toList();
      
      // Add new items to existing ones
      existingItems.addAll(items);
      
      // Convert all items to JSON strings
      final updatedItemsJson = existingItems
          .map((item) => jsonEncode(item.toJson()))
          .toList();
      
      // Save updated list
      return await prefs.setStringList(_storageKey, updatedItemsJson);
    } catch (e) {
      print('Error saving receipt items: $e');
      return false;
    }
  }
  
  // Get all receipt items
  Future<List<ReceiptItem>> getAllReceiptItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itemsJson = prefs.getStringList(_storageKey) ?? [];
      
      return itemsJson
          .map((jsonStr) => ReceiptItem.fromJson(jsonDecode(jsonStr)))
          .toList();
    } catch (e) {
      print('Error getting receipt items: $e');
      return [];
    }
  }
  
  // Get receipt items by category
  Future<List<ReceiptItem>> getReceiptItemsByCategory(String category) async {
    final allItems = await getAllReceiptItems();
    return allItems.where((item) => item.category == category).toList();
  }
  
  // Get receipt items by date range
  Future<List<ReceiptItem>> getReceiptItemsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final allItems = await getAllReceiptItems();
    return allItems.where((item) {
      return item.dateAdded.isAfter(startDate) && 
             item.dateAdded.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
  
  // Get receipt items by month and year
  Future<List<ReceiptItem>> getReceiptItemsByMonth(int month, int year) async {
    final allItems = await getAllReceiptItems();
    return allItems.where((item) {
      return item.dateAdded.month == month && item.dateAdded.year == year;
    }).toList();
  }
  
  // Sort receipt items by date (newest first)
  List<ReceiptItem> sortByDateDescending(List<ReceiptItem> items) {
    final sortedItems = List<ReceiptItem>.from(items);
    sortedItems.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return sortedItems;
  }
  
  // Sort receipt items by date (oldest first)
  List<ReceiptItem> sortByDateAscending(List<ReceiptItem> items) {
    final sortedItems = List<ReceiptItem>.from(items);
    sortedItems.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
    return sortedItems;
  }
  
  // Group receipt items by day
  Map<DateTime, List<ReceiptItem>> groupByDay(List<ReceiptItem> items) {
    final groupedItems = <DateTime, List<ReceiptItem>>{};
    
    for (var item in items) {
      final date = DateTime(
        item.dateAdded.year, 
        item.dateAdded.month, 
        item.dateAdded.day
      );
      
      if (!groupedItems.containsKey(date)) {
        groupedItems[date] = [];
      }
      
      groupedItems[date]!.add(item);
    }
    
    return groupedItems;
  }
  
  // Group receipt items by month
  Map<DateTime, List<ReceiptItem>> groupByMonth(List<ReceiptItem> items) {
    final groupedItems = <DateTime, List<ReceiptItem>>{};
    
    for (var item in items) {
      final date = DateTime(item.dateAdded.year, item.dateAdded.month);
      
      if (!groupedItems.containsKey(date)) {
        groupedItems[date] = [];
      }
      
      groupedItems[date]!.add(item);
    }
    
    return groupedItems;
  }
} 