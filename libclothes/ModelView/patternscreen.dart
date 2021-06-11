import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

class PatternClothes {
  File pickedImage;

  PatternClothes({
    this.pickedImage,
  });
  loadModelpattern() async {
    Tflite.close();
    try {
      String respattern;
      respattern = await Tflite.loadModel(
        model: "assets/pattern_clothes.tflite",
        labels: "assets/labelspattern.txt",
      );
      print(respattern);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  Future predictpattern(File image) async {
    print("Hi Im checking the image");
    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 224.0, // defaults to 117.0
        imageStd: 224.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.5, // defaults to 0.1
        asynch: true // defaults to true
        );
    print("BYE I CHECKED");
    print(recognitions);
    return recognitions;
  }
}
