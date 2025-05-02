// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myflutterfi/providers/comment_provider.dart';
import 'package:myflutterfi/providers/like_provider.dart';
import 'package:myflutterfi/providers/project_provider.dart';
import 'package:myflutterfi/providers/res_appbar_provider.dart';
import 'package:myflutterfi/providers/slide_controller.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/admin/admin_panel.dart';
import 'package:myflutterfi/screens/auth/login_screen.dart';
import 'package:myflutterfi/screens/auth/role_page.dart';
import 'package:myflutterfi/screens/auth/signup_screen.dart';
import 'package:myflutterfi/screens/auth/splash_screen.dart';
import 'package:myflutterfi/screens/common_pages/home_page.dart';
import 'package:myflutterfi/screens/features_screeen/about_us.dart';
import 'package:myflutterfi/screens/user/user_panel.dart';
import 'package:myflutterfi/theme/light_theme.dart';

import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
    apiKey: "AIzaSyCtRPgsjShrgeUachbPqW2rncBqIZ7EIu0",
  authDomain: "myflutterfi-595aa.firebaseapp.com",
  projectId: "myflutterfi-595aa",
  storageBucket: "myflutterfi-595aa.firebasestorage.app",
  messagingSenderId: "647234696427",
  appId: "1:647234696427:web:a76de4874d8549ca5abaae",
  measurementId: "G-Z0DFQE1YVF"
    ),
  );
  runApp(MyApp());
  // Make sure to add any lifecycle listener after initialization
  SystemChannels.lifecycle.setMessageHandler((message) {
    // Handle lifecycle messages here
    return Future.value();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviders()),
ChangeNotifierProvider(create: (_) => ResponsiveAppBarProvider()),
        ChangeNotifierProvider(create: (context) => LikeProvider()),
        ChangeNotifierProvider(create: (context) => CommentProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
      ],
      child: ScreenUtilInit(
        designSize: Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true, // Base size for design,
        builder: (context, child) {
          final isDarkTheme = Provider.of<ThemeProvider>(context).isDarkTheme;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme, // Light theme
            darkTheme: ThemeData.dark(), // Dark theme
            themeMode:
                isDarkTheme ? ThemeMode.dark : ThemeMode.light, // Toggle theme
            routes: {
              '/login': (context) => LoginScreen(),
              '/adminpanel': (context) => AdminHomePage(),

              '/signup': (context) => SignupScreen(),
              '/role': (context) => RolePage(),
              '/home': (context) => HomePage(),
              '/aboutus': (context) => AboutUsPage(),
              '/userpanel': (context) => UserPanel(),
            },
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
