import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/const/styles.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/common_pages/home_page.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/gradient_text.dart';
import 'package:myflutterfi/widgets/switch_toggle.dart';
import 'package:provider/provider.dart';

class CustomMobileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool showSignUpButton;
  final GlobalKey<ScaffoldState> scaffoldKey; // Accept scaffold key
  const CustomMobileAppBar({
    super.key,
    required this.showSignUpButton,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final theme = Provider.of<ThemeProvider>(context);

    // GlobalKey for DrawerController to control the opening/closing of the drawer
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey, // Key to control the drawer's state
      appBar: AppBar(
        backgroundColor:
            theme.isDarkTheme
                ? darkBackgroundColor
                : lightBackgroundColor, // Make AppBar transparent
        elevation: 0, // Remove shadow from the AppBar
        toolbarHeight: 110,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Open the drawer manually using the ScaffoldKey
            scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),
        title: InkWell(
          child: GradientText(
            text: 'Flutter Fi',
            fontSize: 26,
            fw: FontWeight.bold,
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        centerTitle: true,
        actions: [ThemeToggleSwitch()],
      ),
      drawer: CustomDrawers(
        showSignUpButton: showSignUpButton,
      ), // Custom Drawer widget
      body: Center(child: Text('Content Here')), // Your screen content
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
