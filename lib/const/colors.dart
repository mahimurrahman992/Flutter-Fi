import 'package:flutter/material.dart';

//Light Theme
Color lightCardColor = const Color.fromRGBO(255, 255, 255, 0.9); //F0FFFF
Color lightBackgroundColor = Color.fromARGB(255, 217, 196, 226);
Color lightsecdbackColor=Color.fromRGBO(245, 245, 245, 1);
Color lightcardshadowColor=Color.fromRGBO(0, 0, 0, 0.1);
Color lightprimarytextColor =  Colors.black;
Color lightsectextColor =  Colors.grey;
Color lighthinttxtColor=const Color.fromARGB(173, 189, 187, 187);
Color lightbacktxtfieldColor=Color.fromRGBO(245, 245, 245, 1);
Color lighttxtfieldborderColor=Colors.grey;
Color lighttxtfieldfocusborderColor=Color.fromRGBO(252, 163, 193, 1);
Color lightprimarybtnColor=Color.fromARGB(201, 252, 163, 193);
Color lightsecndbtnColor=Colors.deepPurple;
Color lightbtnTextColor=Colors.white;


//Dark theme
Color darkCardColor = const Color.fromRGBO(28, 28, 28, 1); // Dark card background
Color darkBackgroundColor = const Color.fromRGBO(18, 18, 18, 1); // Dark grey/black background
Color darkSecdbackColor = const Color.fromRGBO(34, 34, 34, 1); // Slightly lighter grey for secondary background
Color darkCardShadowColor = const Color.fromRGBO(0, 0, 0, 0.4); // Stronger shadow for dark mode
Color darkPrimaryTextColor = Colors.white; // White text for contrast on dark background
Color darkSecTextColor = Colors.grey; // Muted grey for secondary text
Color darkHintTxtColor = Colors.blueGrey; // Subtle hint text color for placeholders
Color darkBackTxtFieldColor = const Color.fromARGB(255, 138, 136, 136); // Dark background for text fields
Color darkTxtFieldBorderColor = Colors.grey; // Grey borders for text fields
Color darkTxtFieldFocusBorderColor = const Color.fromARGB(201, 252, 163, 193); // Focused border color (matches app bar gradient)
Color darkPrimaryBtnColor = const Color.fromARGB(201, 252, 163, 193); // Button color (matches app bar gradient)
Color darkSecndBtnColor = Colors.deepPurple; // Secondary button color
Color darkBtnTextColor = Colors.white; // Button text color

LinearGradient lightbackground_color() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color.fromARGB(255, 155, 85, 174),
      const Color.fromARGB(255, 84, 132, 187),
    ],
  );
}
LinearGradient darkbackground_color() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color.fromARGB(48, 155, 85, 174),
      const Color.fromARGB(72, 84, 132, 187),
    ],
  );
}
