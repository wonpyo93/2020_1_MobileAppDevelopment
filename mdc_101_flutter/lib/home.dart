import 'package:Shrine/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  var myDatabase = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MySearchPage()));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            debugPrint("fk it's not working");
            return LinearProgressIndicator();
          }
          return _buildGrid(context, snapshot.data.documents);
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Pages'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildGrid(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView(
      children: snapshot.map((data) => _buildGridCards(context, data)),
    );
  }

  Widget _buildGridCards(BuildContext context, DocumentSnapshot data) {
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    final record = Record.fromSnapshot(data);
    return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: record.ID,
              child:AspectRatio(
                aspectRatio: 18 / 11,
                child: Image.asset(
                  record.name,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.location_on,
                    color: Colors.blueAccent,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 12.0, 16.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 4.0),
                          Text(
                            record.name,
                            style: theme.textTheme.title,
                            textScaleFactor: 0.8,
                            maxLines: 1,
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            record.price.toString(),
                            style: theme.textTheme.subtitle,
                            textScaleFactor: 0.8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

class Record {
  final String name;
  final int price;
  final String image;
  final int ID;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['upvote'] != null),
        assert(map['downvote'] != null),
        name = map['name'],
        price = map['price'],
        image = map['image'],
        ID = map['ID'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$ID>";
}