import 'package:flutter/material.dart';
import 'Categories.dart';
import 'Statistic.dart';
import 'ReceiptHistoryScreen.dart';

class MoreMenu extends StatelessWidget {
  final VoidCallback toggleVisibility;

  const MoreMenu({required this.toggleVisibility, super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 0), // Shift left by the widget's width
      child: Column(
        children: [
          SizedBox(
            width: 173.52,
            height: 155.60, // Increased height to accommodate new button
            child: Stack(
              children: [
                Container(
                  width: 173.52,
                  height: 155.60, // Increased height
                  decoration: ShapeDecoration(
                    color: const Color(0xFF422655),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFF422655)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Positioned(
                  left: 6.39,
                  top: 10.95,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Categories(),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 35,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD5D1D1),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            color: Color(0xFF422655),
                            fontSize: 20,
                            fontFamily: 'Righteous',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 7,
                  top: 56,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Statistic(),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 35,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD5D1D1),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Statistic',
                          style: TextStyle(
                            color: Color(0xFF422655),
                            fontSize: 20,
                            fontFamily: 'Righteous',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // New Receipt History button
                Positioned(
                  left: 7,
                  top: 102, // Positioned below the Statistics button
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReceiptHistoryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 35,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD5D1D1),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Receipt History',
                          style: TextStyle(
                            color: Color(0xFF422655),
                            fontSize: 20,
                            fontFamily: 'Righteous',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
