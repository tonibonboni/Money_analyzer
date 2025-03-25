import 'package:flutter/material.dart';
class Firstpage extends StatelessWidget {
  const Firstpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFF86BBB2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 11,
                top: 274,
                child: SizedBox(
                  width: 197,
                  height: 150,
                  child: SizedBox(
                    width: 197,
                    height: 150,
                    child: Text(
                      'HELLO, LET’S ANALYZE!',
                      style: TextStyle(
                        color: const Color(0xFF422655),
                        fontSize: 40,
                        fontFamily: 'Righteous',
                        fontWeight: FontWeight.w400,
                        shadows: [Shadow(offset: const Offset(0, 4), blurRadius: 4, color: const Color(0xFF000000).withOpacity(0.25))],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 228,
                top: 206,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  child: Container(
                    width: 316,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF422655),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 249,
                top: 330,
                child: Container(
                  width: 64,
                  height: 70,
                  padding: const EdgeInsets.all(12),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF422655),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFF86BBB2)),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: const FlutterLogo(),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 313,
                top: 741,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF422655),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 1.97,
                        top: 2.43,
                        child: Transform(
                          transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(0.02),
                          child: const SizedBox(
                            width: 27.35,
                            height: 24.71,
                            child: FlutterLogo(),
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