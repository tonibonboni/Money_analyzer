import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/receipt_item.dart';
import '../services/receipt_service.dart';
import 'Categories.dart';

class ReceiptHistoryScreen extends StatefulWidget {
  const ReceiptHistoryScreen({Key? key}) : super(key: key);

  @override
  _ReceiptHistoryScreenState createState() => _ReceiptHistoryScreenState();
}

class _ReceiptHistoryScreenState extends State<ReceiptHistoryScreen> {
  final ReceiptService _receiptService = ReceiptService();
  List<ReceiptItem> _allItems = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  
  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final items = await _receiptService.getAllReceiptItems();
      setState(() {
        _allItems = _receiptService.sortByDateDescending(items);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading items: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Group items by receipt ID
  Map<String, List<ReceiptItem>> _groupByReceiptId() {
    final Map<String, List<ReceiptItem>> grouped = {};
    
    for (var item in _allItems) {
      if (!grouped.containsKey(item.receiptId)) {
        grouped[item.receiptId] = [];
      }
      grouped[item.receiptId]!.add(item);
    }
    
    return grouped;
  }
  
  // Calculate the receipt total
  String _calculateReceiptTotal(List<ReceiptItem> items) {
    final Map<String, double> totals = {};
    
    for (var item in items) {
      if (!totals.containsKey(item.currency)) {
        totals[item.currency] = 0;
      }
      totals[item.currency] = (totals[item.currency] ?? 0) + item.price;
    }
    
    return totals.entries
        .map((entry) => '${entry.value.toStringAsFixed(2)} ${entry.key}')
        .join(', ');
  }
  
  @override
  Widget build(BuildContext context) {
    final CategoryManager categoryManager = CategoryManager();
    final groupedByReceipt = _groupByReceiptId();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF86BBB2),
        elevation: 0,
        title: const Text(
          'Receipt History',
          style: TextStyle(
            color: Color(0xFF422655),
            fontSize: 24,
            fontFamily: 'Righteous',
            fontWeight: FontWeight.w400,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF422655),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadItems,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF86BBB2),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF422655)))
            : _allItems.isEmpty
                ? const Center(
                    child: Text(
                      'No receipts found',
                      style: TextStyle(
                        color: Color(0xFF422655),
                        fontSize: 18,
                        fontFamily: 'Righteous',
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: groupedByReceipt.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final receiptId = groupedByReceipt.keys.elementAt(index);
                      final receiptItems = groupedByReceipt[receiptId]!;
                      
                      // Use the first item for receipt date
                      final receiptDate = receiptItems.first.dateAdded;
                      
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFF422655),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('EEEE, MMMM d, yyyy').format(receiptDate),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    _calculateReceiptTotal(receiptItems),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: receiptItems.length,
                              itemBuilder: (context, itemIndex) {
                                final item = receiptItems[itemIndex];
                                return ListTile(
                                  title: Text(
                                    item.name,
                                    style: const TextStyle(
                                      color: Color(0xFF422655),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Text(
                                    '${item.price.toStringAsFixed(2)} ${item.currency}',
                                    style: const TextStyle(
                                      color: Color(0xFF422655),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Icon(
                                        categoryManager.getIconForCategory(item.category),
                                        size: 16,
                                        color: const Color(0xFF422655).withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.category,
                                        style: TextStyle(
                                          color: const Color(0xFF422655).withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
} 