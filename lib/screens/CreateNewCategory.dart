import 'package:flutter/material.dart';
class Createmenu extends StatelessWidget {
  const Createmenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 286,
          height: 253,
          child: Stack(
            children: [
              Positioned(
                left: 6,
                top: 0,
                child: Container(
                  width: 280,
                  height: 253,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFF422655)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 47,
                top: 17,
                child: SizedBox(
                  width: 192,
                  height: 28,
                  child: SizedBox(
                    width: 192,
                    height: 28,
                    child: Text(
                      'Create new category',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF422655),
                        fontSize: 20,
                        fontFamily: 'Righteous',
                        fontWeight: FontWeight.w400,
                        height: 1.40,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 154,
                top: 99,
                child: Container(
                  width: 110,
                  height: 27,
                  decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                ),
              ),
              const Positioned(
                left: 0,
                top: 99,
                child: SizedBox(
                  width: 154,
                  height: 36,
                  child: SizedBox(
                    width: 154,
                    height: 36,
                    child: Text(
                      'Choose name:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF422655),
                        fontSize: 20,
                        fontFamily: 'Righteous',
                        fontWeight: FontWeight.w400,
                        height: 1.40,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 92,
                top: 189,
                child: SizedBox(
                  width: 111,
                  height: 30,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 111,
                          height: 30,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF422655),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 3,
                        top: 0,
                        child: SizedBox(
                          width: 104,
                          height: 17,
                          child: SizedBox(
                            width: 104,
                            height: 17,
                            child: Text(
                              'Create',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Righteous',
                                fontWeight: FontWeight.w400,
                                height: 1.87,
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
      ],
    );
  }
}