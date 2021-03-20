import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';

import '../model/user.dart';
import '../model/users.dart';
import '../screens/admin_screen.dart';

class EditUserScreen extends StatefulWidget {
  /* @required
  final String id;
  const EditUserScreen({Key key, @required this.id}) : super(key: key);*/

  static const routeName = '/edit-product';

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _ageFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _fullnameFocusNode = FocusNode();
  final _countryFocusNode = TextEditingController();
  final _stateFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedUser = Userr(
    userid: null,
    email: '',
    password: '',
    // age: 0,
    country: '',
    //fullname: '',
    state: '',
  );
  var _initValues = {
    'email': '',
    'password': '',
    //'age': '',
    'country': '',
    //'fullname': '',
    'state': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final userId = ModalRoute.of(context).settings.arguments as String;
      if (userId != null) {
        _editedUser =
            Provider.of<Users>(context, listen: false).findById(userId);
        _initValues = {
          'email': _editedUser.email,
          'password': _editedUser.password,
          //'age': _editedUser.age.toString(),
          'country': _editedUser.country,
          //'fullname': _editedUser.fullname,

          // 'imageUrl': _editedUser.imageUrl,
          'state': _editedUser.state,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _ageFocusNode.dispose();
    _fullnameFocusNode.dispose();
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedUser.userid != null) {
      await Provider.of<Users>(context, listen: false)
          .updateUser(_editedUser.userid, _editedUser);
    } else {
      try {
        // await Provider.of<Users>(context, listen: false).addUser(_editedUser);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      appBar: AppBar(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        automaticallyImplyLeading: false,
        title: Text(
          'Edit User',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.27,
            color: DesignCourseAppTheme.nearlyBlue,
          ),
        ),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _form,
              child: new ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: 300,
                            child: TextFormField(
                              initialValue: _initValues['email'],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                icon: const Icon(
                                  Icons.email,
                                  color: DesignCourseAppTheme.nearlyBlue,
                                ),
                                hintText: 'Enter a email address',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedUser = Userr(
                                  userid: _editedUser.userid,
                                  email: value,
                                  password: _editedUser.password,
                                  //age: _editedUser.age,
                                  country: _editedUser.country,
                                  //fullname: _editedUser.fullname,
                                  state: _editedUser.state,
                                );
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.mic,
                              size: 22,
                              color: DesignCourseAppTheme
                                  .nearlyBlue, /* _isListening ? Icons.mic : Icons.mic_none*/
                            ),

                            /* onPressed: _listen,*/
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: 300,
                            child: TextFormField(
                              initialValue: _initValues['password'],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                icon: const Icon(
                                  Icons.lock,
                                  color: DesignCourseAppTheme.nearlyBlue,
                                ),
                                hintText: 'Enter password',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedUser = Userr(
                                  userid: _editedUser.userid,
                                  email: _editedUser.email,
                                  password: value,
                                  //age: _editedUser.age,
                                  country: _editedUser.country,
                                  // fullname: _editedUser.fullname,
                                  state: _editedUser.state,
                                );
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.mic,
                              size: 22,
                              color: DesignCourseAppTheme.nearlyBlue,
                              /* _isListening ? Icons.mic : Icons.mic_none*/
                            ),

                            /* onPressed: _listen,*/
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                              width: 300,
                              child: TextFormField(
                                initialValue: _initValues['age'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                  hintText: 'Enter your age',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  labelText: 'Age',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_ageFocusNode);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide a value.';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number.';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Please enter a number greater than zero.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedUser = Userr(
                                    userid: _editedUser.userid,
                                    email: _editedUser.email,
                                    password: _editedUser.password,
                                    // age: int.parse(value),
                                    country: _editedUser.country,
                                    //fullname: _editedUser.fullname,
                                    state: _editedUser.state,
                                  );
                                },
                                keyboardType: TextInputType.number,
                              )),
                          GestureDetector(
                            child: Icon(
                              Icons.mic,
                              size: 22,
                              color: DesignCourseAppTheme.nearlyBlue,
                              /* _isListening ? Icons.mic : Icons.mic_none*/
                            ),

                            /* onPressed: _listen,*/
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                              width: 300,
                              child: TextFormField(
                                initialValue: _initValues['country'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  icon: const Icon(
                                    Icons.location_on,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                  hintText: 'Enter your country',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  labelText: 'Country',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter Country';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedUser = Userr(
                                    userid: _editedUser.userid,
                                    email: _editedUser.email,
                                    password: _editedUser.password,
                                    //age: _editedUser.age,
                                    country: value,
                                    //fullname: _editedUser.fullname,
                                    state: _editedUser.state,
                                  );
                                },
                                keyboardType: TextInputType.text,
                              )),
                          GestureDetector(
                            child: Icon(
                              Icons.mic,
                              size: 22,
                              color: DesignCourseAppTheme.nearlyBlue,
                              /* _isListening ? Icons.mic : Icons.mic_none*/
                            ),

                            /* onPressed: _listen,*/
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                              width: 300,
                              child: TextFormField(
                                initialValue: _initValues['fullname'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  icon: const Icon(
                                    Icons.person,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                  hintText: 'Enter your Full name',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_fullnameFocusNode);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your Name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedUser = Userr(
                                    userid: _editedUser.userid,
                                    email: _editedUser.email,
                                    password: _editedUser.password,
                                    //age: _editedUser.age,
                                    country: _editedUser.country,
                                    //fullname: value,
                                    state: _editedUser.state,
                                  );
                                },
                                keyboardType: TextInputType.text,
                              )),
                          GestureDetector(
                            child: Icon(
                              Icons.mic,
                              size: 22,
                              color: DesignCourseAppTheme.nearlyBlue,
                              /* _isListening ? Icons.mic : Icons.mic_none*/
                            ),

                            /* onPressed: _listen,*/
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                              width: 300,
                              child: TextFormField(
                                initialValue: _initValues['state'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  icon: const Icon(
                                    Icons.location_city,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                  hintText: 'Enter your State',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  labelText: 'State',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your state';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedUser = Userr(
                                    userid: _editedUser.userid,
                                    email: _editedUser.email,
                                    password: _editedUser.password,
                                    //age: _editedUser.age,
                                    country: _editedUser.country,
                                    //fullname: _editedUser.fullname,
                                    state: value,
                                  );
                                },
                                keyboardType: TextInputType.text,
                              )),
                          GestureDetector(
                            child: Icon(
                              Icons.mic,
                              size: 22,
                              color: DesignCourseAppTheme.nearlyBlue,
                              /* _isListening ? Icons.mic : Icons.mic_none*/
                            ),

                            /* onPressed: _listen,*/
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Expanded(
                      child: new Container(
                        decoration: BoxDecoration(
                          color: DesignCourseAppTheme.nearlyBlue,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          border: Border.all(
                              color: DesignCourseAppTheme.nearlyBlue),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white24,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            onTap: () {
                              if (_form.currentState.validate()) {
                                _saveForm();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Adminprofile();
                                }));
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Processing Data')));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, left: 18, right: 18),
                              child: GestureDetector(
                                child: Center(
                                  child: Text(
                                    'Submit',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.27,
                                        color:
                                            DesignCourseAppTheme.nearlyWhite),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]))),
    );
  }
}
