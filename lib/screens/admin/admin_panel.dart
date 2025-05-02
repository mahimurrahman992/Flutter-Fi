
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/admin/admin_blogs.dart';
import 'package:myflutterfi/screens/admin/create_blog.dart';
import 'package:myflutterfi/screens/admin/user_interaction.dart';
import 'package:myflutterfi/screens/admin/view_all_blogs.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';
import 'package:provider/provider.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabs = [
    CreateBlogPage(),
    ViewBlogsPage(),
    UserInteractionsPage(adminEmail: FirebaseAuth.instance.currentUser!.email!),
    AdminBlogsPage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800; // Mobile screen check
    return Scaffold(
     key: _scaffoldKey, // Assign the key to Scaffold
      appBar:
          isMobile
              ? CustomMobileAppBar(
                showSignUpButton: true,
                scaffoldKey: _scaffoldKey, // Pass key to the mobile app bar
              )
              : CustomAppBar(
                showSignUpButton: true,
              ), // AppBar for large screens

      drawer: CustomDrawers(showSignUpButton: true), // Custom Drawer widget,
      body: _tabs[_selectedTabIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          // Ensure consistent colors for the BottomNavigationBar in both themes
          primaryColor: theme.isDarkTheme ? Colors.deepPurple : Colors.deepPurple,
          canvasColor: theme.isDarkTheme
              ? Color.fromARGB(201, 252, 163, 193)
              : Color.fromARGB(201, 252, 163, 193), // Background color for the BottomNavigationBar
          unselectedWidgetColor: theme.isDarkTheme ? Colors.white : Colors.black, // Unselected item color
        ),
        child: BottomNavigationBar(selectedItemColor: Colors.deepPurple,
          currentIndex: _selectedTabIndex,
          onTap: _onTabSelected,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Create Blog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility),
              label: 'View Blogs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'User Interactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'My Blogs',
            ),
          ],
        ),
      ),
    );
  }
}
