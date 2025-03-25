import 'package:flutter/material.dart';
class SideBarDiagram extends StatelessWidget {
  const SideBarDiagram({super.key});

  @override
   Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("user@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text("U", style: TextStyle(fontSize: 40)),
            ),
          ),
          ListTile(
            title: Text("Item 1"),
            onTap: () {
              // Добавете действие при натискане
            },
          ),
          ListTile(
            title: Text("Item 2"),
            onTap: () {
              // Добавете действие при натискане
            },
          ),
        ],
      ),
    );
  }
}

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
                  height: 78,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 320,
                          height: 78,
                          decoration: const BoxDecoration(color: Color(0xFF422655)),
                        ),
                      ),
                      const Positioned(
                        left: 48,
                        top: 22,
                        child: SizedBox(
                          width: 146,
                          height: 34,
                          child: SizedBox(
                            width: 146,
                            height: 34,
                            child: Text(
                              'Create',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
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
                left: 38,
                top: 100,
                child: SizedBox(
                  width: 274,
                  height: 114,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 274,
                          height: 45,
                          child: SizedBox(
                            width: 274,
                            height: 45,
                            child: Text(
                              'Choose category:',
                              style: TextStyle(
                                color: Color(0xFF422655),
                                fontSize: 30,
                                fontFamily: 'Righteous',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        top: 65,
                        child: SizedBox(
                          width: 208,
                          height: 49,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 208,
                                  height: 49,
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
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 267,
                child: Container(
                  width: 288,
                  height: 11,
                  decoration: const BoxDecoration(color: Color(0xFF422655)),
                ),
              ),
              Positioned(
                left: 37,
                top: 300,
                child: SizedBox(
                  width: 245,
                  height: 264,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 72,
                        top: 0,
                        child: SizedBox(
                          width: 102,
                          height: 42,
                          child: SizedBox(
                            width: 102,
                            height: 42,
                            child: Text(
                              'Period:',
                              style: TextStyle(
                                color: Color(0xFF422655),
                                fontSize: 30,
                                fontFamily: 'Righteous',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 64,
                        child: SizedBox(
                          width: 245,
                          height: 200,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 245,
                                  height: 200,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF422655),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 19,
                                top: 31,
                                child: SizedBox(
                                  width: 113,
                                  height: 28,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 5,
                                        child: Container(
                                          width: 17,
                                          height: 17,
                                          decoration: const BoxDecoration(color: Colors.white),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 35,
                                        top: 0,
                                        child: SizedBox(
                                          width: 78,
                                          height: 28,
                                          child: SizedBox(
                                            width: 78,
                                            height: 28,
                                            child: Text(
                                              'March',
                                              style: TextStyle(
                                                color: Colors.white,
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
                                left: 19,
                                top: 59,
                                child: SizedBox(
                                  width: 100,
                                  height: 22,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 5,
                                        child: Container(
                                          width: 17,
                                          height: 17,
                                          decoration: const BoxDecoration(color: Colors.white),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 35,
                                        top: 0,
                                        child: SizedBox(
                                          width: 65,
                                          height: 22,
                                          child: SizedBox(
                                            width: 65,
                                            height: 22,
                                            child: Text(
                                              'April',
                                              style: TextStyle(
                                                color: Colors.white,
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
                                left: 19,
                                top: 87,
                                child: SizedBox(
                                  width: 86,
                                  height: 22,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 5,
                                        child: Container(
                                          width: 17,
                                          height: 17,
                                          decoration: const BoxDecoration(color: Colors.white),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 35,
                                        top: 0,
                                        child: SizedBox(
                                          width: 51,
                                          height: 22,
                                          child: SizedBox(
                                            width: 51,
                                            height: 22,
                                            child: Text(
                                              'May',
                                              style: TextStyle(
                                                color: Colors.white,
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 585,
                child: Container(
                  width: 282,
                  height: 11,
                  decoration: const BoxDecoration(color: Color(0xFF422655)),
                ),
              ),
              Positioned(
                left: 54,
                top: 633,
                child: SizedBox(
                  width: 210,
                  height: 30,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 80,
                          height: 30,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF422655),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 19,
                                top: 7,
                                child: SizedBox(
                                  width: 52,
                                  height: 15,
                                  child: SizedBox(
                                    width: 52,
                                    height: 15,
                                    child: Text(
                                      'Create',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
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
                        left: 130,
                        top: 0,
                        child: SizedBox(
                          width: 80,
                          height: 30,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF422655),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 22,
                                top: 8,
                                child: SizedBox(
                                  width: 41,
                                  height: 12,
                                  child: SizedBox(
                                    width: 41,
                                    height: 12,
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
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
      ],
    );
  }
