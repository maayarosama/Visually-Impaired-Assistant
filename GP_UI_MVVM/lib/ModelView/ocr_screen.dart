import 'package:best_flutter_ui_templates/View/ouptutPage.dart';
import 'package:best_flutter_ui_templates/design_course/home_design_course.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:best_flutter_ui_templates/model/OCR.dart';

class OCR extends StatefulWidget {
  final String option;
  const OCR({Key key, @required this.option}) : super(key: key);
  @override
  OCRscreen createState() => OCRscreen(option: this.option);
}

class OCRscreen extends State<OCR> {
  String option;

  OCRscreen({this.option});

  var ocr = OCRR(
    pickedImage: null,
  );
  var _initValues = {
    'pickedImage': '',
  };

  bool isImageLoaded = false;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      ocr.pickedImage = tempStore;
      isImageLoaded = true;
    });
    readText();
  }

  void check() {
    if (option == "camera") {
      print(option);
      pickCamImage();
    } else
      print(option);
    pickGalleryImage();
  }

  Future pickGalleryImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      ocr.pickedImage = tempStore;
      isImageLoaded = true;
    });
    readText();
  }

  Future pickCamImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      ocr.pickedImage = tempStore;
      isImageLoaded = true;
    });
    readText();
  }

  Future readText() async {
    FirebaseVisionImage ourImage =
        FirebaseVisionImage.fromFile(ocr.pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    List<String> output = [];

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        output.add(line.text);
      }
    }
//outputPage(output, ocr.pickedImage)));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                outputPage(output: output, pickedImage: ocr.pickedImage)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        body: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: CupertinoColors.lightBackgroundGray,
          title: Text("Are you sure?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("yes"),
                  onTap: () {
                    check();
                  },
                ),
                Padding(padding: EdgeInsets.all(16.0)),
                GestureDetector(
                  child: Text("No"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DesignCourseHomeScreen(),
                        ));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
