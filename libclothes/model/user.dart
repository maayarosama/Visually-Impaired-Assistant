import 'package:flutter/foundation.dart';

class Userr with ChangeNotifier {
  final String userid;
  // final String faceid;
  final String country;
  final String email;
  final String password;
  final String fullname;
  final String age;

  final String state;

  Userr({
    @required this.userid,
    @required this.email,
    @required this.password,
    @required this.country,
    @required this.state,
    this.fullname,
    this.age,
    //this.faceid,
  });
}
