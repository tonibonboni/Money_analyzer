import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'CategoryExpensMenu.dart';
import '../utils/category_utils.dart';
import '../models/receipt_item.dart';
import '../services/storage_service.dart';
import 'category_history.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StorageService _storageService = StorageService();
  List<String> categoryNames = CategoryUtils.getPredefinedCategories();
  Map<String, List<ReceiptItem>> _categoryItems = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryItems();
  }

  Future<void> _loadCategoryItems() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, List<ReceiptItem>> result = {};
    for (String category in categoryNames) {
      result[category] = await _storageService.getItemsByCategory(category);
    }

    setState(() {
      _categoryItems = result;
      _isLoading = false;
    });
  }

  // Get the total amount spent in the category
  double _getCategoryTotal(String category) {
    final items = _categoryItems[category] ?? [];
    return items.fold(0, (sum, item) => sum + item.price);
  }

  // Get the most recent transaction date
  String _getLatestTransactionDate(String category) {
    final items = _categoryItems[category] ?? [];
    if (items.isEmpty) return 'No transactions';
    
    items.sort((a, b) => b.date.compareTo(a.date));
    return DateFormat('MMM d, yyyy').format(items.first.date);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: screenWidth * 0.75, // Sidebar width as 75% of screen width
        child: Drawer(
          child: Categoryexpensmenu(),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _scaffoldKey.currentState?.openDrawer(); // Open sidebar on swipe
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.08,
                alignment: Alignment.center,
                child: const Text(
                  'Categories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF422655),
                    fontSize: 40,
                    fontFamily: 'Righteous',
                    fontWeight: FontWeight.w400,
                    height: 0.70,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Pull to refresh
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadCategoryItems,
                  child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: categoryNames.length,
                    itemBuilder: (context, index) {
                      final category = categoryNames[index];
                      final items = _categoryItems[category] ?? [];
                      final totalAmount = _getCategoryTotal(category);
                      final latestDate = _getLatestTransactionDate(category);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryHistoryScreen(
                                category: category,
                                onItemsUpdated: _loadCategoryItems,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category icon and name
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: CategoryUtils.getCategoryColor(category).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        CategoryUtils.getCategoryIcon(category),
                                        color: CategoryUtils.getCategoryColor(category),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        category,
                                        style: const TextStyle(
                                          color: Color(0xFF422655),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                // Total amount
                                Text(
                                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Color(0xFF422655),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Count of items
                                Text(
                                  '${items.length} items',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Latest transaction date
                                Text(
                                  'Latest: $latestDate',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                // View more button
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryHistoryScreen(
                                            category: category,
                                            onItemsUpdated: _loadCategoryItems,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'View History',
                                      style: TextStyle(
                                        color: Color(0xFF422655),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
