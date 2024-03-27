import 'package:fip_my_version/pages/language_page.dart';
import 'package:fip_my_version/pages/main_page.dart';
import 'package:fip_my_version/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:fip_my_version/core/core.dart';

class PagesProvider extends StatefulWidget {
  @override
  _PagesProviderState createState() => _PagesProviderState();
}

class _PagesProviderState extends State<PagesProvider> {
  final PageController _pageController = PageController(initialPage: 1);
  int _selectedIndex = 1;

  // Pages for the PageView
  final List<Widget> _pages = [
    ChatsScreen(), // Page 1
    HomePage(),
    SettingsScreen(), // Page 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      // Bottom navigation bar remains static
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
    );
  }
}
