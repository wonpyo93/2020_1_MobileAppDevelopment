import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class MySearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MySearchPageState();
  }
}

class MyFilter {
  MyFilter({this.isExpanded: false, this.header, this.body});

  bool isExpanded;
  final String header;
  final String body;
}

class MySearchPageState extends State<MySearchPage> {
  var checkBoxValue = [false, false, false, false, false];
  var checkBoxString = ['', '', '', '', ''];
  var checkBoxStringFinal = ['', '', '', '', ''];
  String checkBoxFinal;
  int finalNum;

  DateTime _dateTimeIn;
  DateTime _dateTimeOut;

  DateFormat dateFormat = DateFormat("yyyy.MM.dd (EEE)");
  List<MyFilter> _filters = <MyFilter>[
    MyFilter(header: "Filter", body: "Body lol"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _filters[index].isExpanded = !_filters[index].isExpanded;
                    });
                  },
                  children: _filters.map((MyFilter filter) {
                    return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  filter.header,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 25),
                                ),
                                SizedBox(width: 70.0),
                                Text(
                                  'select filters',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ],
                            ),
                          );
                        },
                        isExpanded: filter.isExpanded,
                        body: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 150.0),
                                  Checkbox(
                                    value: checkBoxValue[0],
                                    onChanged: (bool value) {
                                      print(value);
                                      setState(() {
                                        checkBoxValue[0] = value;
                                        if (checkBoxValue[0] == true) {
                                          checkBoxString[0] = 'No Kids Zone';
                                        } else {
                                          checkBoxString[0] = '';
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    'No Kids Zone',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 150.0),
                                  Checkbox(
                                    value: checkBoxValue[1],
                                    onChanged: (bool value) {
                                      print(value);
                                      setState(() {
                                        checkBoxValue[1] = value;
                                        if (checkBoxValue[1] == true) {
                                          checkBoxString[1] = 'Pet Friendly';
                                        } else {
                                          checkBoxString[1] = '';
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    'Pet Friendly',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 150.0),
                                  Checkbox(
                                    value: checkBoxValue[2],
                                    onChanged: (bool value) {
                                      print(value);
                                      setState(() {
                                        checkBoxValue[2] = value;
                                        if (checkBoxValue[2] == true) {
                                          checkBoxString[2] = 'Free breakfast';
                                        } else {
                                          checkBoxString[2] = '';
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    'Free breakfast',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 150.0),
                                  Checkbox(
                                    value: checkBoxValue[3],
                                    onChanged: (bool value) {
                                      print(value);
                                      setState(() {
                                        checkBoxValue[3] = value;
                                        if (checkBoxValue[3] == true) {
                                          checkBoxString[3] = 'Free Wifi';
                                        } else {
                                          checkBoxString[3] = '';
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    'Free Wifi',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 150.0),
                                  Checkbox(
                                    value: checkBoxValue[4],
                                    onChanged: (bool value) {
                                      print(value);
                                      setState(() {
                                        checkBoxValue[4] = value;
                                        if (checkBoxValue[4] == true) {
                                          checkBoxString[4] =
                                              'Electric Car Charging';
                                        } else {
                                          checkBoxString[4] = '';
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    'Electric Car Charging',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ));
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                  child: Text(
                    'Date',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 25),
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.redAccent,
                                      ),
                                      Text('check-in',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ))
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      _dateTimeIn == null
                                          ? 'No Date Yet'
                                          : dateFormat.format(_dateTimeIn) +
                                              '\n9:30 am',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: FlatButton(
                                child: Text('select date'),
                                color: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2001),
                                          lastDate: DateTime(2222))
                                      .then((date) {
                                    setState(() {
                                      _dateTimeIn = date;
                                    });
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 25),
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.redAccent,
                                      ),
                                      Text('check-out',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ))
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      _dateTimeOut == null
                                          ? 'No Date Yet'
                                          : dateFormat.format(_dateTimeOut) +
                                              '\n9:30 am',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: FlatButton(
                                child: Text('select date'),
                                color: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2001),
                                          lastDate: DateTime(2222))
                                      .then((date) {
                                    setState(() {
                                      _dateTimeOut = date;
                                    });
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                finalNum = 0;
                for (int i = 0; i < 5; i++) {
                  if (checkBoxValue[i] == true) {
                    checkBoxStringFinal[finalNum] = checkBoxString[i];
                    finalNum++;
                  }
                }
                checkBoxFinal = checkBoxStringFinal[0];
                for (int i = 1; i < 5; i++) {
                  if (checkBoxStringFinal[i] != '') {
                    checkBoxFinal =
                        checkBoxFinal + ' / ' + checkBoxStringFinal[i];
                  }
                }
              });
              giveAlert(context);
            },
            child: const Text('Search', style: TextStyle(fontSize: 30)),
            color: Colors.blue,
            textColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  void giveAlert(BuildContext context) {
    var alertDialog = AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        color: Colors.blue,
        child: Center(
          child: Text(
            "\nPlease check \nyour choice :)\n",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.menu,
                  color: Colors.blue,
                  size: 30.0,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(checkBoxFinal, style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                  size: 30.0,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'IN',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'OUT',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _dateTimeIn == null
                          ? 'No Date Yet'
                          : dateFormat.format(_dateTimeIn) + '\n9:30 am',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      _dateTimeIn == null
                          ? 'No Date Yet'
                          : dateFormat.format(_dateTimeIn) + '\n9:30 am',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Search',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  color: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 20),
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 15),),
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
