import 'package:flutter/material.dart';
import 'package:myflutterfi/widgets/custom_appbar.dart';
import 'package:myflutterfi/widgets/custom_drawer.dart';
import 'package:myflutterfi/widgets/custom_mob_appbar.dart';



class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800;
    return Scaffold(
      key: _scaffoldKey,
      appBar: isMobile
          ? CustomMobileAppBar(
              showSignUpButton: true,
              scaffoldKey: _scaffoldKey,
            )
          : CustomAppBar(
              showSignUpButton: true,
            ),
      drawer: CustomDrawers(showSignUpButton: true),
      backgroundColor: Colors.green,
      body: Column(
        children: [],
      ),
    );
  }
}
