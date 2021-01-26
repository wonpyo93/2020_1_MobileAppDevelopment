import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add.dart';
import 'login.dart';
import 'detail.dart';
import 'profile.dart';

class Record {
  final String id;
  final String name;
  final int price;
  final String image;
  final int likes;
  final DocumentReference reference;
  final String description;
  final Timestamp timeModify;
  final Timestamp timeCreated;
  final String creatorID;
  final List<dynamic> likedPeople;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['ID'] != null),
        assert(map['image'] != null),
        assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['description'] != null),
        assert(map['likes'] != null),
        assert(map['creatorID'] != null),
        id = map['ID'],
        name = map['name'],
        creatorID = map['creatorID'],
        price = map['price'],
        likes = map['likes'],
        description = map['description'],
        timeCreated = map['timeCreated']??null,
        timeModify = map['timeModify']??null,
        likedPeople = map['likedPeople']??null,
        image = map['image'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "item$id>";
}

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  String dropdownValue = 'ASC';

void rebuild() { setState((){}); }

  List<Card> _buildGridCards(BuildContext context, List<DocumentSnapshot> snapshot) {
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    debugPrint(theUid);
    return snapshot.map((product) {
      final record = Record.fromSnapshot(product);
      final imageRef = FirebaseStorage.instance.ref().child(record.image);
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 30 / 11,
              child: FutureBuilder(
                future: imageRef.getDownloadURL(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  return Image.network(snapshot.data);
                }),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 8.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      record.name,
                      style: theme.textTheme.title,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      formatter.format(record.price),
                      style: theme.textTheme.body2,
                    ),
                  ],
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text('more'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyDetailPage(record)));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  void sortASC() {

  }

  void sortDESC() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            semanticLabel: 'account',
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        title: Text('SHRINE'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              semanticLabel: 'add',
            ),
            onPressed: () async {
              final temp = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage()));
              rebuild();
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
      Center(
        child: DropdownButton<String>(
        value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              rebuild();
            });
          },
          items: <String>['ASC', 'DESC']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                var t = snapshot.data.documents;
                if(dropdownValue == 'ASC')
                  {
                    t.sort((a, b) => a.data['price'].compareTo(b.data['price']));
                  }
                else
                  {
                    t.sort((a, b) => b.data['price'].compareTo(a.data['price']));
                  }
                return
                  GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(16.0),
                      childAspectRatio: 8.0 / 9.0,
                      children: _buildGridCards(context, t)
                );
              },
            ),
          ),
        ],
      )
    );
  }
}
