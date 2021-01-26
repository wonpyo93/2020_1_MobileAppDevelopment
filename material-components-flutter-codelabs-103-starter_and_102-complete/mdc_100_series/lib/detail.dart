import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'modify.dart';
import 'login.dart';

class MyDetailPage extends StatefulWidget {
  Record _record;
  MyDetailPage(Record record)
  {
    _record = record;
  }

  @override
  State<StatefulWidget> createState() {
    return MyDetailPageState(_record);
  }
}

class MyDetailPageState extends State<MyDetailPage>
{
  Record _record;
  MyDetailPageState(Record record)
  {
    _record = record;
  }
  var imageRef;
  final now = FieldValue.serverTimestamp();

  final databaseReference = Firestore.instance;
  bool pressedBefore = false;

  @override
  void initState() {
    super.initState();
    imageRef = FirebaseStorage.instance.ref().child(_record.image);
  }

  void deleteProduct() async {
    await databaseReference.collection("products")
        .document(_record.id)
        .delete();
  }

  void makeSnackBar(context, String ment) {
    final snackBar = SnackBar(content: Text(ment));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void plusplusLike() async {

    await databaseReference.collection("products")
        .document(_record.id)
        .updateData({
      'likes': _record.likes + 1,
      'likedPeople' : FieldValue.arrayUnion([theUid]),
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              semanticLabel: 'edit',
            ),
            onPressed: () {
              if(theUid == _record.creatorID) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyPage(_record)));
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              semanticLabel: 'delete',
            ),
            onPressed: () {
              if(theUid == _record.creatorID) {
                deleteProduct();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
              future: imageRef.getDownloadURL(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return CircularProgressIndicator();
                return Image.network(snapshot.data);
              }),
          SizedBox(height: 50,),
          Text(
            _record.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent,fontSize: 30),
            textScaleFactor: 0.8,
            maxLines: 1,
          ),
          SizedBox(height: 12.0),
          Text(
            '\$${_record.price.toString()}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent,fontSize: 30),
            textScaleFactor: 0.8,
            maxLines: 1,
          ),
          SizedBox(height: 12.0),
          Text(
            _record.description,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent,fontSize: 30),
            textScaleFactor: 0.8,
          ),
          SizedBox(height: 12.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width:270,),
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                    ),
                    onPressed: () async {
                      if(_record.likedPeople.contains(theUid) == false) {
                        //여기선 ++ 하기
                        plusplusLike();
                        makeSnackBar(context ,'I LIKE IT!');
                        var doc = await Firestore.instance.collection('products').document(_record.id).get();
                        _record = Record.fromSnapshot(doc);
                      }
                      else {
                        makeSnackBar(context, 'You can only do it once !!');
                      }
                    },
                  );
                }
              ),
              SizedBox(width: 20,),
              StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('products').document(_record.id).snapshots(),
                builder: (context, snapshot) {

                  return Text(
                      (!snapshot.hasData) ? _record.likes.toString() : snapshot.data['likes'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red,fontSize: 30),
                    textScaleFactor: 0.8,
                    maxLines: 1,
                  );
                }
              ),
              SizedBox(width: 20,),
            ],
          ),
          SizedBox(height: 30.0),
          Text(
            'creator: < ${_record.creatorID} >',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,fontSize: 15),
            textScaleFactor: 0.8,
            maxLines: 1,
          ),
          Text(
            'timeCreated: ${_record.timeCreated.toDate().toString()}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,fontSize: 15),
            textScaleFactor: 0.8,
            maxLines: 1,
          ),
          Text(
            'timeModified: ${_record.timeModify.toDate().toString()}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,fontSize: 15),
            textScaleFactor: 0.8,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}