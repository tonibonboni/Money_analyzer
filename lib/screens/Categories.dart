import 'package:flutter/material.dart';
import 'CategoryExpensMenu.dart';
import 'CategoryDetailScreen.dart';

// Create a class to manage categories that can be accessed from anywhere
class CategoryManager {
  static final CategoryManager _instance = CategoryManager._internal();
  
  factory CategoryManager() {
    return _instance;
  }
  
  CategoryManager._internal();
  
  // List of category names
  final List<String> categoryNames = [
    'Food', 'Transport', 'Entertainment', 'Shopping', 'Bills', 'Other'
  ];
  
  // Map of category icons
  final Map<String, IconData> categoryIcons = {
    'Food': Icons.fastfood,
    'Transport': Icons.directions_car,
    'Entertainment': Icons.movie,
    'Shopping': Icons.shopping_bag,
    'Bills': Icons.receipt,
    'Other': Icons.more_horiz,
  };
  
  // Get icon for a category
  IconData getIconForCategory(String category) {
    return categoryIcons[category] ?? Icons.category;
  }
}

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CategoryManager categoryManager = CategoryManager();

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
              SizedBox(height: screenHeight * 0.1),
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
              SizedBox(height: screenHeight * 0.05),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: categoryManager.categoryNames.length,
                  itemBuilder: (context, index) {
                    final categoryName = categoryManager.categoryNames[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the category detail screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailScreen(
                              categoryName: categoryName,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth * 0.20,
                            height: screenHeight * 0.10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              categoryManager.getIconForCategory(categoryName),
                              color: const Color(0xFF422655),
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            categoryName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF422655),
                              fontSize: 12,
                              fontFamily: 'Righteous',
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
