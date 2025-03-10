import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';
import 'package:test_flutter_fi/widgets/gradient_text.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final int? top;
   final int? bottom;
    final int? left;
     final int? right;

  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.color,
    required this.textColor,
    this.borderRadius = 12.0,
    this.elevation = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
    this.fontSize = 16.0,
    this.icon,this.bottom,this.left,this.right,this.top, CircularProgressIndicator? child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.only(
        top: top?.toDouble() ?? 0.0,
        left: left?.toDouble() ?? 0.0,
        right: right?.toDouble() ?? 0.0,
        bottom: bottom?.toDouble() ?? 0.0,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor),
              const SizedBox(width: 8.0),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomTextButton extends StatelessWidget {
  final String label;
  final int? top;
  final int? bottom;
  final int? left;
  final int? right;
  final VoidCallback onPressed;
  final Color? textColor;
  final double fontSize;
 
  final IconData? icon;

  const CustomTextButton({
    Key? key,
    required this.label,
    required this.onPressed,
     this.textColor,

    this.fontSize = 22.0,
    this.icon,
    this.top,
    this.bottom,
    this.left,
    this.right, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.only(
        top: top?.toDouble() ?? 0.0,
        left: left?.toDouble() ?? 0.0,
        right: right?.toDouble() ?? 0.0,
        bottom: bottom?.toDouble() ?? 0.0,
      ),
      child: TextButton(
      
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor),
              const SizedBox(width: 8.0),
            ],
          GradientText2(text: label, fontSize: fontSize,fw: FontWeight.bold,)
            
          ],
        ),
      ),
    );
  }
}