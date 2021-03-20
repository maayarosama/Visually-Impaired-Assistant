import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class ApBarUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return AppBar(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      automaticallyImplyLeading: false,
      title: Text(
        'Home',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: 0.27,
          color: DesignCourseAppTheme.nearlyBlue,
        ),
      ),
    );
  }
}
