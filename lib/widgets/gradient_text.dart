import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fw;
  const GradientText({Key? key, required this.text,required this.fontSize,this.fw}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [Color.fromARGB(200, 249, 137, 174), Colors.deepPurple], // Gradient colors
          tileMode: TileMode.mirror, // Tile mode for the gradient
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize, // Size of the text
          fontWeight: fw,
          color: Colors.white, // Color can be anything, but the gradient takes precedence
        ),
      ),
    );
  }
}

class GradientText2 extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fw;
  const GradientText2({Key? key, required this.text,required this.fontSize,this.fw}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [ Colors.white,Color.fromARGB(200, 249, 137, 174),], // Gradient colors
          tileMode: TileMode.mirror, // Tile mode for the gradient
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize, // Size of the text
          fontWeight: fw,
          color: Colors.white, // Color can be anything, but the gradient takes precedence
        ),
      ),
    );
  }
}
