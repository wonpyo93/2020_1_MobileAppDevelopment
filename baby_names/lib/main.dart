import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baby Name Votes')),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {showAlertDialog(context);},
      ),
    );
  }


  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: GestureDetector( onTap: () {record.reference.delete();}, child: Icon(Icons.delete) ),
          title: Text(record.name, textScaleFactor: 1.2,),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector( onTap: () => Firestore.instance.runTransaction((transaction) async {
                    final freshSnapshot = await transaction.get(record.reference);
                    final fresh = Record.fromSnapshot(freshSnapshot);
                    await transaction
                        .update(record.reference, {'upvote': fresh.upvote + 1});
                  }), child: Icon(Icons.thumb_up) ),
                  SizedBox(height: 5,),
                  Text(record.upvote.toString()),
                ],
              ),
              SizedBox(width: 20,),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector( onTap: () => Firestore.instance.runTransaction((transaction) async {
                    final freshSnapshot = await transaction.get(record.reference);
                    final fresh = Record.fromSnapshot(freshSnapshot);
                    await transaction
                        .update(record.reference, {'downvote': fresh.downvote + 1});
                  }), child: Icon(Icons.thumb_down) ),
                  SizedBox(height: 5,),
                  Text(record.downvote.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) async {
    final databaseReference = Firestore.instance;
    final TextEditingController _textController = new TextEditingController();

    void createRecord(String tempName) async {
      await databaseReference.collection("baby")
          .document(tempName)
          .setData({
        'name': tempName,
        'upvote': 0,
        'downvote': 0,
      });
    }

    void _handleSubmitted(String text) {
      _textController.clear();
    }

    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a baby name'),
          content: TextField(
            controller: _textController,
            onSubmitted: _handleSubmitted,
            decoration: InputDecoration(
              labelText: 'Baby Name',
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ADD'),
              onPressed: () {
                createRecord(_textController.text);
                Navigator.pop(context, "OK");
              },
            ),
          ],
        );
      },
    );
  }
}

class Record {
  final String name;
  final int upvote;
  final int downvote;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['upvote'] != null),
        assert(map['downvote'] != null),
        name = map['name'],
        upvote = map['upvote'],
        downvote = map['downvote'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$upvote>";
}