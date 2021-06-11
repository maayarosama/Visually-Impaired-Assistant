import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

class ColorClothes {
  File pickedImage;

  ColorClothes({
    this.pickedImage,
  });
  loadModelcolor() async {
    Tflite.close();
    try {
      String rescolor;
      rescolor = await Tflite.loadModel(
        model: "assets/color.tflite",
        labels: "assets/labelscolor.txt",
      );
      print(rescolor);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  Future predictcolor(File image) async {
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
