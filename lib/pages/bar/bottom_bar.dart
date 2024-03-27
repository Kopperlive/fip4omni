import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fip_my_version/core/theme_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  BottomBar({
    this.selectedIndex = 0,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color backgroundColor = themeProvider.isDarkMode
        ? Colors.white
        : Color.fromRGBO(21, 21, 21, 1);
    Color reversebackgroundColor = themeProvider.isDarkMode
        ? Color.fromRGBO(21, 21, 21, 1)
        : Colors.white;
    Color iconColor = themeProvider.isDarkMode
        ? Color.fromRGBO(251, 139, 37, 1)
        : Color.fromRGBO(255, 201, 151, 1);
    Color buttonBackgroundColor = themeProvider.isDarkMode
        ? Colors.white
        : Color.fromRGBO(251, 139, 37, 1);

    return CurvedNavigationBar(
      index: selectedIndex,
      height: 60,
      onTap: onTabSelected,
      color: backgroundColor,
      backgroundColor: reversebackgroundColor,
      items: <Widget>[
        Icon(Icons.message_outlined, color: iconColor),
        Icon(Icons.home_outlined, color: iconColor),
        Icon(Icons.settings_outlined, color: iconColor),
      ],
      buttonBackgroundColor: buttonBackgroundColor,
    );
  }
}
