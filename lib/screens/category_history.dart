import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/receipt_item.dart';
import '../services/storage_service.dart';
import '../utils/category_utils.dart';

class CategoryHistoryScreen extends StatefulWidget {
  final String category;
  final Function? onItemsUpdated;
  
  const CategoryHistoryScreen({
    Key? key,
    required this.category,
    this.onItemsUpdated,
  }) : super(key: key);

  @override
  _CategoryHistoryScreenState createState() => _CategoryHistoryScreenState();
}

class _CategoryHistoryScreenState extends State<CategoryHistoryScreen> {
  final StorageService _storageService = StorageService();
  List<ReceiptItem> _items = [];
  bool _isLoading = true;
  String _currentFilter = 'All';
  final List<String> _filterOptions = ['All', 'This Month', 'Last Month', 'This Year'];
  
  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  
  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    
    List<ReceiptItem> items = await _storageService.getItemsByCategory(widget.category);
    
    // Apply filter
    items = _applyFilter(items);
    
    // Sort by date (newest first)
    items = _storageService.sortItemsByDate(items);
    
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }
  
  List<ReceiptItem> _applyFilter(List<ReceiptItem> items) {
    final now = DateTime.now();
    
    switch (_currentFilter) {
      case 'This Month':
        return items.where((item) => 
          item.date.month == now.month && 
          item.date.year == now.year).toList();
          
      case 'Last Month':
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return items.where((item) => 
          item.date.month == lastMonth.month && 
          item.date.year == lastMonth.year).toList();
          
      case 'This Year':
        return items.where((item) => 
          item.date.year == now.year).toList();
          
      case 'All':
      default:
        return items;
    }
  }
  
  // Group items by date
  Map<String, List<ReceiptItem>> _groupItemsByDate() {
    Map<String, List<ReceiptItem>> groupedItems = {};
    
    for (var item in _items) {
      String dateKey = DateFormat('yyyy-MM-dd').format(item.date);
      if (!groupedItems.containsKey(dateKey)) {
        groupedItems[dateKey] = [];
      }
      groupedItems[dateKey]!.add(item);
    }
    
    return groupedItems;
  }
  
  // Get formatted date for display
  String _getFormattedDate(String dateKey) {
    final date = DateTime.parse(dateKey);
    return DateFormat('MMMM d, yyyy').format(date);
  }
  
  // Delete an item
  Future<void> _deleteItem(ReceiptItem item) async {
    await _storageService.deleteItem(item);
    await _loadItems();
    if (widget.onItemsUpdated != null) {
      widget.onItemsUpdated!();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final groupedItems = _groupItemsByDate();
    final sortedDates = groupedItems.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category} History',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF422655),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Filter by period'),
                  content: SizedBox(
                    width: double.minPositive,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filterOptions.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(_filterOptions[index]),
                          value: _filterOptions[index],
                          groupValue: _currentFilter,
                          onChanged: (String? value) {
                            Navigator.pop(context);
                            if (value != null) {
                              setState(() {
                                _currentFilter = value;
                              });
                              _loadItems();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _items.isEmpty 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CategoryUtils.getCategoryIcon(widget.category),
                    size: 50,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No items found for ${widget.category}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Filter: $_currentFilter',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadItems,
              child: ListView.builder(
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                  final dateKey = sortedDates[index];
                  final dateItems = groupedItems[dateKey]!;
                  final formattedDate = _getFormattedDate(dateKey);
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Color(0xFF422655),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Items for this date
                      ...dateItems.map((item) => Dismissible(
                        key: Key('${item.name}-${item.price}-${item.date.toIso8601String()}'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Item'),
                              content: Text('Are you sure you want to delete "${item.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) => _deleteItem(item),
                        child: ListTile(
                          leading: Icon(
                            CategoryUtils.getCategoryIcon(widget.category),
                            color: CategoryUtils.getCategoryColor(widget.category),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('HH:mm').format(item.date),
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Text(
                            '${item.currency}${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF422655),
                            ),
                          ),
                        ),
                      )).toList(),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
    );
  }
} 