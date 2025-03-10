import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMobAppbar extends StatelessWidget implements PreferredSizeWidget  {
  const CustomMobAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      color: Colors.pink,
    );
  }
  
  @override
  // TODO: implement preferredSize
 Size get preferredSize => Size.fromWidth(30);
}
