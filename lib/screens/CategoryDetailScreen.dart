import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/receipt_item.dart';
import '../services/receipt_service.dart';
import 'Categories.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;

  const CategoryDetailScreen({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> with SingleTickerProviderStateMixin {
  final ReceiptService _receiptService = ReceiptService();
  List<ReceiptItem> _items = [];
  bool _isLoading = true;
  String _currentGrouping = 'day'; // 'day' or 'month'
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadItems();
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }
  
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentGrouping = _tabController.index == 0 ? 'day' : 'month';
      });
    }
  }
  
  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final items = await _receiptService.getReceiptItemsByCategory(widget.categoryName);
      setState(() {
        _items = _receiptService.sortByDateDescending(items);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading items: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final categoryManager = CategoryManager();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF86BBB2),
        elevation: 0,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Color(0xFF422655),
            fontSize: 24,
            fontFamily: 'Righteous',
            fontWeight: FontWeight.w400,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF422655),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF422655),
          labelColor: const Color(0xFF422655),
          unselectedLabelColor: Colors.white,
          tabs: const [
            Tab(text: 'By Day'),
            Tab(text: 'By Month'),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFF86BBB2),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF422655)))
            : _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryManager.getIconForCategory(widget.categoryName),
                          size: 70,
                          color: const Color(0xFF422655).withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No items in this category yet',
                          style: TextStyle(
                            color: Color(0xFF422655),
                            fontSize: 18,
                            fontFamily: 'Righteous',
                          ),
                        ),
                      ],
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildGroupedList(groupByDay: true),
                      _buildGroupedList(groupByDay: false),
                    ],
                  ),
      ),
    );
  }
  
  Widget _buildGroupedList({required bool groupByDay}) {
    final Map<DateTime, List<ReceiptItem>> groupedItems = groupByDay
        ? _receiptService.groupByDay(_items)
        : _receiptService.groupByMonth(_items);
    
    // Sort the dates (keys) in descending order
    final sortedDates = groupedItems.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    return ListView.builder(
      itemCount: sortedDates.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final items = groupedItems[date]!;
        
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      groupByDay
                          ? DateFormat('EEEE, MMMM d, yyyy').format(date)
                          : DateFormat('MMMM yyyy').format(date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _calculateTotalForDate(items),
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
                itemCount: items.length,
                itemBuilder: (context, itemIndex) {
                  final item = items[itemIndex];
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
                    subtitle: Text(
                      DateFormat('HH:mm').format(item.dateAdded),
                      style: TextStyle(
                        color: const Color(0xFF422655).withOpacity(0.6),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  String _calculateTotalForDate(List<ReceiptItem> items) {
    double total = 0;
    String currency = '';
    
    // This is simplified and assumes all items have the same currency
    if (items.isNotEmpty) {
      currency = items.first.currency;
      for (var item in items) {
        total += item.price;
      }
    }
    
    return '${total.toStringAsFixed(2)} $currency';
  }
} 