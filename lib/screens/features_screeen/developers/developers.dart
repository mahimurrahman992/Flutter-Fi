import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_fi/screens/features_screeen/developers/user_profile_screen.dart';
import 'package:test_flutter_fi/widgets/custom_appbar.dart';

class DevelopersPage extends StatefulWidget {
  @override
  _DevelopersPageState createState() => _DevelopersPageState();
}

class _DevelopersPageState extends State<DevelopersPage> {
  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _admins = [];
  List<QueryDocumentSnapshot> _users = [];
  List<QueryDocumentSnapshot> _filteredAdmins = [];
  List<QueryDocumentSnapshot> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchDevelopers();
    _searchController.addListener(_filterDevelopers);
  }

  // Fetch Admins and Users from Firestore
  void _fetchDevelopers() {
    FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Admin')
        .get()
        .then((snapshot) {
      setState(() {
        _admins = snapshot.docs;
        _filteredAdmins = _admins;
      });
    });

    FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'User')
        .get()
        .then((snapshot) {
      setState(() {
        _users = snapshot.docs;
        _filteredUsers = _users;
      });
    });
  }

  // Function to filter developers based on the search query
  void _filterDevelopers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAdmins = _admins
          .where((admin) => admin['fullName'].toLowerCase().contains(query))
          .toList();
      _filteredUsers = _users
          .where((user) => user['fullName'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 217, 196, 226),
      appBar: CustomAppBar(showSignUpButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Developers',
                  hintText: 'Enter name to search',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20), // Spacing between search bar and results

              // Admins Section
              _filteredAdmins.isEmpty
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admins',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _filteredAdmins.length,
                            itemBuilder: (context, index) {
                              var admin = _filteredAdmins[index].data()
                                  as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfilePage(
                                          userId: _filteredAdmins[index]
                                              .id), // Pass userId to UserProfilePage
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    title: Text(admin['fullName'] ?? 'No Name'),
                                    subtitle:
                                        Text(admin['email'] ?? 'No Email'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

              // Users Section
              _filteredUsers.isEmpty
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Users',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              var user = _filteredUsers[index].data()
                                  as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfilePage(
                                          userId: _filteredUsers[index]
                                              .id), // Pass userId to UserProfilePage
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    title: Text(user['fullName'] ?? 'No Name'),
                                    subtitle: Text(user['email'] ?? 'No Email'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
