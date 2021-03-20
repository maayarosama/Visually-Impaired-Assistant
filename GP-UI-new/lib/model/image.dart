import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Image {
  String imageUrl;
  String data;
  DateTime date;
  DocumentReference reference;

  Image(String imageUrl, String data, DateTime date) {
    this.imageUrl = imageUrl;
    this.data = data;
    this.date = date;
  }

  Image.fromMap(Map<String, dynamic> map, {this.reference}) {
    imageUrl = map["imageUrl"];
    data = map["data"];
    date = map["date"];
  }

  Image.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  toJson() {
    return {
      'imageUrl': imageUrl,
      'data': data,
      'date': date,
    };
  }
}
