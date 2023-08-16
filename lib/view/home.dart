import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:euclipse/utility/navigator.dart';
import 'package:euclipse/view/calendar/calendar_home.dart';
import 'package:euclipse/view/homepage/homepage.dart';
import 'package:euclipse/view/onboarding/onboarding.dart';
import 'package:euclipse/view/summary/summary_page.dart';
import 'package:euclipse/view/time_table_gen/generate_time_table.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late PageController _pageController;

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const CalendarHome(),
    const ClassSummary(),
    const TimeTableGen(
      isUpdate: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  Widget _navBar() {
    return CustomNavigationBar(
        iconSize: 30,
        selectedColor: Colors.white,
        strokeColor: Colors.white,
        unSelectedColor: secondaryColor,
        backgroundColor: primaryColor,
        items: [
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.home,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.calendar_today_outlined,
              size: 26,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.summarize,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.table_chart_outlined,
            ),
          ),

          // CustomNavigationBarItem(
          //   icon: const Icon(
          //     Icons.info_outlined,
          //   ),
          // ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => _onItemTapped(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        bottomNavigationBar: _navBar(),
        resizeToAvoidBottomInset: true,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: _pages,
        ));
  }
}
