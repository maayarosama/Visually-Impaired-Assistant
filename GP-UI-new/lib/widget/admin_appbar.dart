import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/src/material/raised_button.dart';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';

// #docregion MyApp
class AdminAppbar extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: DesignCourseAppTheme.nearlyBlack //change your color here
            ),
        backgroundColor: DesignCourseAppTheme.nearlyBlue,
        title: Text(
          'Users',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.27,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
  // #enddocregion build
}
