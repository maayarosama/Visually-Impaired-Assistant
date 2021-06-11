import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import './user.dart';
import '../model/HTTPException.dart';

class Users with ChangeNotifier {
  List<Userr> _items = [];
  BuildContext context;

  List<Userr> get items {
    return [..._items];
  }

  Userr findById(String id) {
    return _items.firstWhere((user) => user.userid == id);
  }

  Userr findByFullname(String fullname) {
    return _items.firstWhere((user) => user.fullname == fullname);
  }

  Future<void> SignIn() async {
    const url =
        'https://graduation-5a0e5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final dbData = json.decode(response.body) as Map<String, dynamic>;
      final List<Userr> dbUsers = [];
      dbData.forEach((key, data) {
        dbUsers.add(Userr(
          userid: key,
          email: data['email'],
          password: data['password'],
          fullname: data['fullname'],
          age: data['age'],

          country: data['country'],

          state: data['state'],
          //faceid: data['faceid'],
        ));
      });
      _items = dbUsers;
      notifyListeners();
    } on Exception catch (e) {
      print(e.toString());
      throw (e);
    }

    final usersData = Provider.of<Users>(context);

    print(usersData.items.length);
  }

  /////lecture 14
  Future<void> fetchAndSetUsers() async {
    const url =
        'https://graduation-5a0e5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final dbData = json.decode(response.body) as Map<String, dynamic>;
      final List<Userr> dbUsers = [];
      dbData.forEach((key, data) {
        dbUsers.add(Userr(
          userid: key,
          email: data['email'],
          password: data['password'],
          fullname: data['fullname'],
          age: data['age'],

          country: data['country'],

          state: data['state'],
          //faceid: data['faceid'],
        ));
      });
      _items = dbUsers;
      notifyListeners();
    } on Exception catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> addUser(String email, String password, String age,
      String country, String fullname, String state) async {
    const url =
        'https://graduation-5a0e5-default-rtdb.firebaseio.com/users.json';

    return http
        .post(url,
            body: json.encode({
              'email': email,
              'password': password,
              'age': age,
              'country': country,
              'fullname': fullname,
              'state': state,
              // 'faceid': user.faceid,
            }))
        .then((res) {
      final newUser = Userr(
          email: email,
          password: password,
          country: country,
          state: state,
          userid: jsonDecode(res.body)['name']);
      _items.add(newUser);
      notifyListeners();
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> updateUser(String id, Userr newUser) async {
    final url =
        'https://graduation-5a0e5-default-rtdb.firebaseio.com/users/$id.json';

    final userIndex = _items.indexWhere((user) => user.userid == id);
    if (userIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'email': newUser.email,
            'fullname': newUser.fullname,
            'age': newUser.age,
            'password': newUser.password,
            'country': newUser.country,
            'state': newUser.state,
          }));
      _items[userIndex] = newUser;
      notifyListeners();
    }
  }

  void deleteUser(String id) {
    final url =
        'https://graduation-5a0e5-default-rtdb.firebaseio.com/users/$id.json';
    final existingInd = _items.indexWhere((element) => element.userid == id);
    var existing = _items[existingInd];
    _items.removeAt(existingInd);
    http.delete(url).then((res) {
      if (res.statusCode >= 400) {
        _items.insert(existingInd, existing);
        notifyListeners();
        print(res.statusCode);
        throw HTTPException('Delete Failid for id is $id');
      }
    });
    notifyListeners();
  }
}
