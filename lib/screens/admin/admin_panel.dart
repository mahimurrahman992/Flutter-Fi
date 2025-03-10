// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_fi/screens/admin/admin_blogs.dart';
import 'package:test_flutter_fi/screens/admin/create_blog.dart';
import 'package:test_flutter_fi/screens/admin/user_interaction.dart';
import 'package:test_flutter_fi/screens/admin/view_all_blogs.dart';

import 'package:test_flutter_fi/services/firebase_services.dart';
import 'package:test_flutter_fi/widgets/custom_button.dart';
import 'package:test_flutter_fi/widgets/custom_textfield.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  late TabController _tabController;
  final List<Widget> _tabs = [
    CreateBlogPage(),
    ViewBlogsPage(),
    UserInteractionsPage(adminEmail: FirebaseAuth.instance.currentUser!.email!),
    AdminBlogsPage()

  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          onTap: _onTabSelected,
          tabs: [
            Tab(text: 'Create Blog'),
            Tab(text: 'View Blogs'),
            Tab(text: 'User Interactions'),
            Tab(text: 'My Blogs'),
          ],
        ),
      ),
      body: _tabs[_selectedTabIndex],
    );
  }
}
