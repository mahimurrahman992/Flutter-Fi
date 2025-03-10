import 'package:flutter/material.dart';
import 'package:test_flutter_fi/widgets/custom_appbar.dart';


class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showSignUpButton: true,
      ),
      backgroundColor: Colors.green,
      body: Column(
        children: [],
      ),
    );
  }
}
