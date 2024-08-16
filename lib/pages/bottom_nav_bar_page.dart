import 'dart:developer';

import 'package:flutter/material.dart';

import '../apis/apis.dart';
import 'create_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _selectedIndex = 0;
  static final List _pages = [
    HomePage(),
    const CreatePage(),
    // ProfilePage(user: APIs.me),
  ];

  void _onItemTapped(int index) {
    if(index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePage()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
