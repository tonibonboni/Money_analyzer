import 'package:flutter/material.dart';
import 'Statistic.dart';
import 'package:money_analyzer/main.dart';

class Ssmenu extends StatelessWidget {
  const Ssmenu({super.key, required void Function() toggleVisibility});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                left: 5,
                top: 18,
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
                        left: 54,
                        top: 4,
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
              Positioned(
                left: 4,
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
                        left: 35,
                        top: 5.68,
                        child: SizedBox(
                          width: 92.34,
                          height: 21.16,
                          child: SizedBox(
                            width: 92.34,
                            height: 21.16,
                            child: Text(
                              'Statistics',
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
                      GestureDetector(
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
            ],
          ),
        ),
      ],
    );
  }
}