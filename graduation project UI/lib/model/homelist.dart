import 'package:best_flutter_ui_templates/View/home_design_course.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
      HomeList(
        imagePath: 'assets/design_course/design_course.png',
        navigateScreen: DesignCourseHomeScreen(),
      ),
  ];
}
