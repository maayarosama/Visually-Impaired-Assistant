import 'dart:async';
import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';

void main() => runApp(Settings());

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.27,
            color: DesignCourseAppTheme.nearlyBlue,
          ),
        ),
      ),
      backgroundColor: CupertinoColors.darkBackgroundGray,
      body: ListView(
        padding: const EdgeInsets.only(top: 8, left: 10),
        children: <Widget>[
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Security',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openSecuritySettings();
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.settings_applications,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Application settings',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openAppSettings();
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(Icons.settings_display,
                    color: DesignCourseAppTheme.nearlyBlue),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Display',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openDisplaySettings();
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Notifications',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openNotificationSettings();
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.volume_up,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Sound',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openSoundSettings();
            },
          ),
        ],
      ),
    );
  }

  /// Dispose method to close out and cleanup objects.
  @override
  void dispose() {
    super.dispose();
  }
}
