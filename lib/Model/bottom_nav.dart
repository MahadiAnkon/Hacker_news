import 'package:flutter/material.dart';
import 'package:hacker_news/View/Home_page/home_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (_) => false);
        break;
      case 1:
        Navigator.pushNamed(context, '/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildNavItem(
            context,
            index: 0,
            icon: Icons.home,
            label: 'Home',
          ),
          _buildNavItem(
            context,
            index: 1,
            icon: Icons.settings,
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required int index, required IconData icon, required String label}) {
    Color color = selectedIndex == index
        ? Theme.of(context).colorScheme.primary
        : Colors.grey;

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () => _onItemTapped(context, index),
      tooltip: label,
    );
  }
}
