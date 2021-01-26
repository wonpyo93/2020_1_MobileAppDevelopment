import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class ModifyPage extends StatefulWidget {
  Record _record;

  ModifyPage(Record record)
  {
    _record = record;
  }

  @override
  State<StatefulWidget> createState() {
    return ModifyState(_record);
  }
}



class ModifyState extends State<ModifyPage>
{
  Record _record;
  ModifyState(Record record)
  {
    _record = record;
  }
  var imageRef;
  final now = FieldValue.serverTimestamp();
  var newImageLoaded = false;
  var _image;
  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final productDescription = TextEditingController();
  final defaultURL = "http://handong.edu/site/handong/res/img/logo.png";
  String _uploadedFileURL;
  final databaseReference = Firestore.instance;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      newImageLoaded = true;
    });
  }

  Widget showImage() {
    if(!newImageLoaded)
    {
      return  FutureBuilder(
          future: imageRef.getDownloadURL(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return CircularProgressIndicator();
            return Image.network(snapshot.data);
          });
    }
    else
    {
      return Image.file(_image, width: 300, height: 300);
    }
  }
  void modifyProduct(String tempName, String price, String description) async {
    await databaseReference.collection("products")
        .document(_record.id)
        .updateData({
      'name': tempName,
      'price': int.parse(price),
      'image' : "images/${_record.id}",
      'description': description,
      'timeModify' : FieldValue.serverTimestamp(),
    });
  }

  Future uploadFile(String productName) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${_record.id}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    imageRef = FirebaseStorage.instance.ref().child(_record.image);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
          ),
        ),
        title: Text('Edit'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              modifyProduct(productName.text, productPrice.text, productDescription.text);
              uploadFile(productName.text);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              "Save",
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          showImage(),
          SizedBox(height: 50,),
          IconButton(
            icon: Icon(
              Icons.camera_alt,
            ),
            onPressed: () {
              getImage();
            },
          ),
          TextFormField(
            controller: productName,
            validator: (value) {
              if (value.isEmpty) {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: _record.name,
            ),
          ),
          TextFormField(
            controller: productPrice,
            validator: (value) {
              if (value.isEmpty) {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: _record.price.toString(),
            ),
          ),
          TextFormField(
            controller: productDescription,
            validator: (value) {
              if (value.isEmpty) {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: _record.description,
            ),
          ),
          SizedBox(height: 12.0),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}