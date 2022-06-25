import 'package:flutter/material.dart';
import 'package:rare_crew_task/screens/home_screen.dart';
import 'package:rare_crew_task/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String accessToken, refreshToken;
  const DashboardScreen(
      {Key? key, required this.accessToken, required this.refreshToken})
      : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  static const List<String> _appBarTitles = ['Home Screen', 'Profile Screen'];
  final List<Widget> _screens = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _screens.add(
      HomeScreen(
          accessToken: widget.accessToken, refreshToken: widget.accessToken),
    );
    _screens.add(ProfileScreen(
        accessToken: widget.accessToken, refreshToken: widget.refreshToken));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        backgroundColor: const Color(0xff10ADBC),
      ),
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff10ADBC),
        onTap: _onItemTapped,
      ),
    );
  }
}
