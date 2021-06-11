import 'dart:io';
import 'dart:math';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/View/home_design_course.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class outputPage extends StatefulWidget {
  @override
  final List<String> output;
  final File pickedImage;
  //String downloadUrl=pickedImage.path;
  const outputPage({Key key, @required this.output, @required this.pickedImage})
      : super(key: key);

  _outputPageState createState() => _outputPageState();
}

class _outputPageState extends State<outputPage> with TickerProviderStateMixin {
  @override
  String speakable;
  bool isVisible = true;
  final FlutterTts flutterTts = FlutterTts();
  String myimage;
  Random rando = new Random();
  String downloadUrl;

  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  speak(String str) async {
    setState(() {
      isVisible = false;
    });
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(str);
  }

  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setScreen();
    super.initState();

    mid();
  }

  Future<void> setScreen() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  stopSpeaker() async {
    setState(() {
      isVisible = true;
    });
    await flutterTts.stop();
  }

  mid() {
    var kontan = StringBuffer();
    widget.output.forEach((item) {
      kontan.writeln(item);
    });
    speakable = kontan.toString();
    speak(speakable);
  }

  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: CupertinoColors.darkBackgroundGray,
      child: Scaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    width: MediaQuery.of(context).size.width / 0.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(widget.pickedImage),
                            fit: BoxFit.cover))),

                //child: Image.asset('assets/design_course/webInterFace.png'),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DesignCourseAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      color: CupertinoColors.darkBackgroundGray,
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2.2,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: widget.output.length,
                                  itemBuilder: (_, index) {
                                    return Center(
                                      child: new Text(
                                        widget.output[index],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          //backgroundColor: Colors.white,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 48,
                                    height: 58,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors
                                            .darkBackgroundGray
                                            .withOpacity(0.4),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        border: Border.all(
                                            color: DesignCourseAppTheme.grey
                                                .withOpacity(0.7)),
                                      ),
                                      child: GestureDetector(
                                        child: Icon(
                                          Icons.stop,
                                          color:
                                              DesignCourseAppTheme.nearlyBlue,
                                          size: 24,
                                        ),
                                        onTap: () => stopSpeaker(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 48,
                                    height: 58,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors
                                            .darkBackgroundGray
                                            .withOpacity(0.4),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        border: Border.all(
                                            color: DesignCourseAppTheme.grey
                                                .withOpacity(0.7)),
                                      ),
                                      child: GestureDetector(
                                        child: Icon(
                                          Icons.volume_up,
                                          color:
                                              DesignCourseAppTheme.nearlyBlue,
                                          size: 24,
                                        ),
                                        onTap: () => mid(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                    parent: animationController, curve: Curves.fastOutSlowIn),
                child: Card(
                  color: DesignCourseAppTheme.nearlyBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 10.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: DesignCourseAppTheme.nearlyBlack,
                    ),
                    onTap: () {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              DesignCourseHomeScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
