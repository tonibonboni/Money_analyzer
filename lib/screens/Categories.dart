import 'package:flutter/material.dart';
import 'CategoryExpensMenu.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> categoryNames = [
    'Food', 'Transport', 'Entertainment', 'Shopping', 'Bills', 'Other'
  ];

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
                  itemCount: categoryNames.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth * 0.20,
                            height: screenHeight * 0.10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const FlutterLogo(),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            categoryNames[index],
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
