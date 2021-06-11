import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:best_flutter_ui_templates/design_course_app_theme.dart';

import '../model/users.dart';
import 'users_info.dart';

class Adminprofile extends StatelessWidget {
  // static const routeName = '/user-products';

  Future<void> _refresh(BuildContext context) async {
    Provider.of<Users>(context, listen: false).fetchAndSetUsers();
  }

  @override
  Widget build(BuildContext context) {
    final usersData = Provider.of<Users>(context);
    return Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      appBar: AppBar(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        title: Text(
          'Users',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.27,
            color: DesignCourseAppTheme.nearlyBlue,
          ),
        ),
        iconTheme: IconThemeData(
          color: DesignCourseAppTheme.nearlyBlue, //change your color here
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: usersData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: CupertinoColors.lightBackgroundGray.withOpacity(0.3),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: UserInfo(
                    usersData.items[i].userid,
                    usersData.items[i].email,
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
