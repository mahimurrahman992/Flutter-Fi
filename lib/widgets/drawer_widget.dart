/*import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'package:test_flutter_fi/providers/auth_provider.dart';
import 'package:test_flutter_fi/screens/auth/login_screen.dart';
import 'package:test_flutter_fi/screens/user/profile_screen.dart';


class DrawerWidget extends StatelessWidget {
      
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Center(
              child: Text(
                'Welcome!',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          TextButton(onPressed: () {
            authProvider.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
          }, child: Text('Logout',textAlign: TextAlign.end,),)
        ],
      ),
    );
  }
}
*/