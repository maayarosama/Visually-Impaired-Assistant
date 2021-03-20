import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/model/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

import '../screens/edituser_screen.dart';
import '../model/user.dart';

class UserInfo extends StatelessWidget {
  final String id;
  final String fullname;
  //final String imageUrl;

  UserInfo(this.id, this.fullname);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        fullname,
        style: TextStyle(color: Colors.white),
      ),

      /* leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),*/
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: DesignCourseAppTheme.nearlyBlue,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/edit-product', arguments: id);
              },
              /*onPressed: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserScreen(id),
                    ));
              },*/
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: DesignCourseAppTheme.nearlyBlue),
              onPressed: () async {
                try {
                  provider.Provider.of<Users>(context, listen: false)
                      .deleteUser(id);
                } catch (error) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                  ));
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
