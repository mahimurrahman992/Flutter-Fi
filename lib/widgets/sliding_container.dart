import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:test_flutter_fi/const/styles.dart';
import 'package:test_flutter_fi/providers/slide_controller.dart';

class SlidingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final slideController = context.watch<SlideController>();

    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      top: slideController.isContainerVisible ? 0 : -350.h,
      left: 0,
      right: 0,
      height: 350.h,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          margin: EdgeInsets.symmetric(horizontal: 25.w),
          color: Colors.blue,
          child: Column(
            children: [
              Align(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.cancel_outlined),
                ),
                alignment: Alignment.topRight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        _getSectionTitle(slideController.selectedSection),
                        style: myStyle(22, Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        _getSectionContent(slideController.selectedSection),
                        style: myStyle(16, Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () {
                          _handleSectionAction(slideController.selectedSection);
                        },
                        child: Text('Learn More'),
                      ),
                      _getSectionButton(slideController.selectedSection)
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        _getSectionTitle(slideController.selectedSection),
                        style: myStyle(22, Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        _getSectionContent(slideController.selectedSection),
                        style: myStyle(16, Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () {
                          _handleSectionAction(slideController.selectedSection);
                        },
                        child: Text('Learn More'),
                      ),
                      _getSectionButton(slideController.selectedSection)
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }

  String _getSectionTitle(String section) {
    switch (section) {
      case 'Categories':
        return 'Categories';
      case 'Developers':
        return 'Developers';
      case 'Contact Us':
        return 'Contact Us';
      default:
        return '';
    }
  }

  String _getSectionContent(String section) {
    switch (section) {
      case 'Categories':
        return 'Explore our different categories...';
      case 'Developers':
        return 'Meet the developers...';
      case 'Contact Us':
        return 'Contact us for more information...';
      default:
        return '';
    }
  }

  void _handleSectionAction(String section) {
    // Handle the button action based on the section
    print('Button pressed for: $section');
  }

  Widget _getSectionButton(String section) {
    switch (section) {
      case 'Categories':
        return ElevatedButton(
          onPressed: () {
            print('Exploring categories...');
            // Add navigation or action here
          },
          child: Text('View Categories'),
        );
      case 'Developers':
        return ElevatedButton(
          onPressed: () {
            print('Viewing developer profiles...');
            // Add navigation or action here
          },
          child: Text('Meet the Developers'),
        );
      case 'Contact Us':
        return ElevatedButton(
          onPressed: () {
            print('Opening Contact Us page...');
            // Add navigation or action here
          },
          child: Text('Contact Us'),
        );
      default:
        return SizedBox.shrink(); // No button for undefined sections
    }
  }
}
