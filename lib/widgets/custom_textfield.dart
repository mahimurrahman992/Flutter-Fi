import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_fi/const/colors.dart';
import 'package:test_flutter_fi/const/styles.dart';
import 'package:test_flutter_fi/providers/theme_provider.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? Function(String?) validator;
  final IconButton? suffixIcon;

  const CustomTextField(
      {this.hintText,
      Key? key,
      required this.controller,
      required this.labelText,
      required this.validator,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,labelStyle: myStyle(14, theme.isDarkTheme?Colors.white:darkHintTxtColor),
          hintText: hintText,
          hintStyle: myStyle(
              16, theme.isDarkTheme ? Colors.white : darkHintTxtColor),
          filled: true,
          fillColor: theme.isDarkTheme
              ? darkBackTxtFieldColor
              : lightbacktxtfieldColor,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: theme.isDarkTheme
                    ? lighttxtfieldborderColor
                    : darkTxtFieldBorderColor,
                width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: theme.isDarkTheme
                    ? lighttxtfieldfocusborderColor
                    : darkTxtFieldFocusBorderColor,
                width: 2),
          ),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
        minLines: 1, // Default minimum lines for normal size
        maxLines: null, // Allows it to expand dynamically
      ),
    );
  }
}
