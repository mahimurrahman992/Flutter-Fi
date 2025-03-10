// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/providers/comment_provider.dart';
import 'package:test_flutter_fi/providers/like_provider.dart';
import 'package:test_flutter_fi/providers/project_provider.dart';
import 'package:test_flutter_fi/providers/slide_controller.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';
import 'package:test_flutter_fi/screens/admin/admin_panel.dart';
import 'package:test_flutter_fi/screens/auth/login_screen.dart';
import 'package:test_flutter_fi/screens/auth/role_page.dart';
import 'package:test_flutter_fi/screens/auth/signup_screen.dart';
import 'package:test_flutter_fi/screens/auth/splash_screen.dart';
import 'package:test_flutter_fi/screens/features_screeen/about_us.dart';
import 'package:test_flutter_fi/screens/common_pages/home_page.dart';
import 'package:test_flutter_fi/screens/user/user_panel.dart';
import 'package:test_flutter_fi/theme/light_theme.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyDRvQQMPBR-PW68q3O_OfRJLSVPlxKfp7k',
    appId: '1:453291235022:web:56eccb2c1c1c752365e29f',
    messagingSenderId: '453291235022',
    projectId: 'testflutterfi',
    authDomain: 'testflutterfi.firebaseapp.com',
    storageBucket: 'testflutterfi.firebasestorage.app',
    measurementId: 'G-21BSF4MBNM',
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProviders()),
          ChangeNotifierProvider(
            create: (context) => SlideController(),
          ),
          ChangeNotifierProvider(
            create: (context) => LikeProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CommentProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ProjectProvider(),
          ),
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
              themeMode: isDarkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light, // Toggle theme
              routes: {
                '/login': (context) => LoginScreen(),
                '/adminpanel': (context) => AdminHomePage(),
                // '/userpanel': (context) => UserPanel(),
                '/signup': (context) => SignupScreen(),
                '/role': (context) => RolePage(),
                '/home': (context) => HomePage(),
                '/aboutus': (context) => AboutUsPage(),
                '/userpanel': (context) => UserPanel(),
              },
              home: SplashScreen(),
            );
          },
        ));
  }
}
