import 'package:flutter/material.dart';
import 'package:money_analyzer/main.dart';
import 'Categories.dart';
import 'Statistic.dart';

class Moremenu extends StatelessWidget {
  const Moremenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 178,
          height: 153,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 178,
                  height: 153,
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
                top: 58,
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
                        left: 33.83,
                        top: 7.33,
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
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 7,
                top: 102,
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
                        left: 39.04,
                        top: 7.57,
                        child: SizedBox(
                          width: 87.10,
                          height: 20.81,
                          child: SizedBox(
                            width: 87.10,
                            height: 20.81,
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
                      ),GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Statistic(),
                            ),
                          );
                        })
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 9,
                top: 12,
                child: Container(
                  width: 160,
                  height: 35,
                  padding: const EdgeInsets.only(
                    top: 5.41,
                    left: 54.50,
                    right: 54.50,
                    bottom: 4.59,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD5D1D1),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Start',
                        style: TextStyle(
                          color: Color(0xFF422655),
                          fontSize: 20,
                          fontFamily: 'Righteous',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}