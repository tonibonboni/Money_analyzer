import 'package:flutter/material.dart';
import 'package:money_analyzer/main.dart';
import 'Categories.dart';
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
          height: 111.60,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 173.52,
                  height: 111.60,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF422655),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFF422655)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 7,
                top: 56,
                child: SizedBox(
                  width: 160,
                  height: 35,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
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
                        ),
                      ),
                      const Positioned(
                        left: 29,
                        top: 3.78,
                        child: SizedBox(
                          width: 109.71,
                          height: 17.91,
                          child: SizedBox(
                            width: 109.71,
                            height: 17.91,
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
                      ),GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Categories(),
                            ),
                          );
                        })
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 5,
                top: 11,
                child: SizedBox(
                  width: 160,
                  height: 35,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
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
                        ),
                      ),
                      const Positioned(
                        left: 57.06,
                        top: 6.62,
                        child: SizedBox(
                          width: 51.20,
                          height: 20.35,
                          child: SizedBox(
                            width: 51.20,
                            height: 20.35,
                            child: Text(
                              'Start',
                              style: TextStyle(
                                color: Color(0xFF422655),
                                fontSize: 20,
                                fontFamily: 'Righteous',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Firstpage(),
                            ),
                          );
                        })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),);
  }
}