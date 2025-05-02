import 'package:flutter/material.dart';
import 'package:myflutterfi/screens/features_screeen/about_us.dart';
import 'package:myflutterfi/screens/features_screeen/categories.dart';
import 'package:myflutterfi/screens/features_screeen/developers/developers.dart';
import 'package:myflutterfi/screens/features_screeen/projects/projects.dart';



class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  // This will hold the index of the selected navigation item
  int _selectedIndex = 0;

  // List of pages to navigate to
  final List<Widget> _pages = [
    AboutUsPage(),
    CategoriesPage(),
    DevelopersPage(),
    ProjectsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Perform navigation based on the index
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // You can show content of the selected page here
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(backgroundColor: Colors.blue,
            icon: Icon(Icons.info_outline),
            label: 'About Us',
          ),
          BottomNavigationBarItem(backgroundColor: Colors.blue,
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(backgroundColor: Colors.blue,
            icon: Icon(Icons.group),
            label: 'Developers',
          ),
          BottomNavigationBarItem(backgroundColor: Colors.blue,
            icon: Icon(Icons.work),
            label: 'Projects',
          ),
          BottomNavigationBarItem(backgroundColor: Colors.blue,
            icon: Icon(Icons.contact_mail),
            label: 'Contact Us',
          ),
        ],
      ),
    );
  }
}
