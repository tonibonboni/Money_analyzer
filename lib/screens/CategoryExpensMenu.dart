import 'package:flutter/material.dart';
class Categoryexpensmenu extends StatelessWidget {
  const Categoryexpensmenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 320,
          height: 700,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  width: 320,
                  height: 62,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 320,
                          height: 62,
                          decoration: const BoxDecoration(color: Color(0xFF422655)),
                        ),
                      ),
                      const Positioned(
                        left: 36,
                        top: 14,
                        child: SizedBox(
                          width: 90,
                          height: 34,
                          child: SizedBox(
                            width: 90,
                            height: 34,
                            child: Text(
                              'FOOD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
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
                left: 24,
                top: 287,
                child: Container(
                  width: 272,
                  height: 12,
                  decoration: const BoxDecoration(color: Color(0xFF422655)),
                ),
              ),
              Positioned(
                left: 49,
                top: 311,
                child: SizedBox(
                  width: 222,
                  height: 181,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 222,
                          height: 30,
                          child: SizedBox(
                            width: 222,
                            height: 30,
                            child: Text(
                              'Choose period:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF422655),
                                fontSize: 24,
                                fontFamily: 'Righteous',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 63,
                        child: SizedBox(
                          width: 194,
                          height: 118,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 194,
                                  height: 118,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF422655),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 15,
                                child: SizedBox(
                                  width: 101,
                                  height: 18,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 17,
                                          height: 18,
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFD9D9D9),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 17,
                                        top: 0,
                                        child: SizedBox(
                                          width: 84,
                                          height: 16,
                                          child: SizedBox(
                                            width: 84,
                                            height: 16,
                                            child: Text(
                                              'January',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
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
                                left: 10,
                                top: 50,
                                child: SizedBox(
                                  width: 101,
                                  height: 18,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 17,
                                          height: 18,
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFD9D9D9),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 17,
                                        top: 0,
                                        child: SizedBox(
                                          width: 84,
                                          height: 16,
                                          child: SizedBox(
                                            width: 84,
                                            height: 16,
                                            child: Text(
                                              'February',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 563,
                child: Container(
                  width: 272,
                  height: 12,
                  decoration: const BoxDecoration(color: Color(0xFF422655)),
                ),
              ),
              Positioned(
                left: 49,
                top: 612,
                child: SizedBox(
                  width: 207,
                  height: 35,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 80,
                          height: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF422655),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Create',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Righteous',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 127,
                        top: 0,
                        child: SizedBox(
                          width: 80,
                          height: 35,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 80,
                                  height: 35,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF422655),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 15,
                                top: 7.50,
                                child: SizedBox(
                                  width: 50,
                                  height: 18.75,
                                  child: SizedBox(
                                    width: 50,
                                    height: 18.75,
                                    child: Text(
                                      'Cancel',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
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
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 13,
                top: 111,
                child: SizedBox(
                  width: 293,
                  height: 127,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 164,
                          height: 23,
                          child: SizedBox(
                            width: 164,
                            height: 23,
                            child: Text(
                              'Expens for:',
                              textAlign: TextAlign.center,
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
                      Positioned(
                        left: 150,
                        top: 0,
                        child: SizedBox(
                          width: 143,
                          height: 32,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 143,
                                  height: 32,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF422655),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 66,
                        top: 70,
                        child: Container(
                          width: 195,
                          height: 57,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF422655),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
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