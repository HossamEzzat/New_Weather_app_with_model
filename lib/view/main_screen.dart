import 'package:flutter/material.dart';
import 'package:flutter_weather_app/view/home_screen.dart';
import 'package:flutter_weather_app/view/model_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ModelScreen(), // Add the ModelScreen widget as one of the screens
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny_snowing),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.model_training),
            label: 'Model',
          ),
        ],
      ),
    );
  }
}