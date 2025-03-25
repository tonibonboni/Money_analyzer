import 'package:flutter/material.dart';
import 'package:money_analyzer/screens/SideBarDiagram.dart'; // Препоръчвам да проверите пътя

class Statistic extends StatefulWidget {
  const Statistic({super.key});

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF86BBB2),
      drawer: SideBarDiagram(), // Тук използваме SideBar
      body: Center(
        child: Column(
          children: [
            Container(
              width: 360,
              height: 800,
              child: Stack(
                children: [
                  const Positioned(
                    left: 0,
                    top: 99,
                    child: SizedBox(
                      width: 350,
                      height: 30,
                      child: Text(
                        'Statistics',
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
                  ),
                  Positioned(
                    left: 13,
                    top: 54,
                    child: GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer(); // Отваря страничното меню
                      },
                      child: Container(
                        width: 31,
                        height: 31,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF422655),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Добавете съдържанието за статистика
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
