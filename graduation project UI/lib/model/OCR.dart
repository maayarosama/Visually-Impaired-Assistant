import 'package:flutter/foundation.dart';
import 'dart:io';

class OCRR with ChangeNotifier {
  File pickedImage;
  final String recognizedtext;

  OCRR({
    @required this.pickedImage,
    this.recognizedtext,
  });
}
