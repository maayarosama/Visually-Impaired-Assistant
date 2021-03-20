import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'ocr_screen.dart';

class output_screen extends StatefulWidget {
  @override
  _output_screenState createState() => _output_screenState();
}

class _output_screenState extends State<output_screen> {
  @override
  DateTime _selectedValue = DateTime.now();

  Future getPosts() async {
    /*  var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('tyremrf')
        .document("hVCGeC3hDCOoK3472PWi")
        .collection("info")
        .where("date", isEqualTo: _selectedValue)
        .getDocuments();
    print(qn.documents.length);
    return qn.documents;*/
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue //change your color here
            ),
        title: new Text(
          "History List",
          style: new TextStyle(color: Colors.blue),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OCR()));
        },
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DatePicker(
                        DateTime.now().add(Duration(days: -6)),
                        width: 60,
                        height: 80,
                        //   controller: _controller,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Colors.white,
                        selectedTextColor: Colors.blueAccent,
                        monthTextStyle: new TextStyle(color: Colors.black),
                        dayTextStyle: new TextStyle(color: Colors.black),
                        dateTextStyle: new TextStyle(color: Colors.black),
                        daysCount: 7,
                        onDateChange: (date) {
                          // New date selected
                          setState(() {
                            _selectedValue = date;
                            print(_selectedValue);
                          });
                        },
                      ),
                    ],
                  ),
                  new SizedBox(
                    height: 20,
                  ),
                  new FutureBuilder(
                      future: getPosts(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: new CircularProgressIndicator());
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height / 1.40,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 2.0, left: 3, right: 3),
                                    child: Card(
                                      color: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      child: GestureDetector(
                                        child: new ListTile(
                                          contentPadding: EdgeInsets.all(10.0),
                                          subtitle: Row(
                                            children: <Widget>[
                                              new Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image:
                                                          new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                          snapshot.data[index]
                                                              .data['imageUrl'],
                                                        ),
                                                      ))),
                                              //  Image.network(snapshot.data[index].data['imageUrl'], height: 60,width: 60,),
                                              new SizedBox(
                                                width: 5,
                                              ),

                                              Container(
                                                  height: 60,
                                                  child: VerticalDivider(
                                                      color: Colors.black)),
                                              new SizedBox(
                                                width: 10,
                                              ),

                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Text(
                                                    snapshot.data[index]
                                                        .data['data'],
                                                    style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),
                                                  new SizedBox(
                                                    height: 12,
                                                  ),
                                                  new Text(
                                                    DateFormat('dd-MMM-yyyy')
                                                        .format(snapshot
                                                            .data[index]
                                                            .data['date']
                                                            .toDate())
                                                        .toString(),
                                                    style: new TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
