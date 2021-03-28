import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/custom_drawer/drawer_user_controller.dart';
import 'package:best_flutter_ui_templates/custom_drawer/home_drawer.dart';
import 'package:best_flutter_ui_templates/ModelView/edituser_screen.dart';
import 'feedback_screen.dart';
import 'help_screen.dart';
import 'invite_friend_screen.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/design_course/home_design_course.dart';
import 'settings.dart';
import 'index.dart';

class NavigationHomeScreen extends StatefulWidget {
  final String fullname;
  const NavigationHomeScreen({Key key, @required this.fullname})
      : super(key: key);
  _NavigationHomeScreenState createState() =>
      _NavigationHomeScreenState(fullname: this.fullname);
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  String fullname;
  _NavigationHomeScreenState({this.fullname});

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = DesignCourseHomeScreen(
      fullname: this.fullname,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = DesignCourseHomeScreen();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.About) {
        setState(() {
          screenView = Invite();
        });
      } else if (drawerIndex == DrawerIndex.Settings) {
        setState(() {
          screenView = Settings();
        });
      } else if (drawerIndex == DrawerIndex.EDIT) {
        setState(() {
          screenView = EditUserScreen();
        });
      } else {
        screenView = MyindexApp();
        //do in your way......
      }
    }
  }
}
