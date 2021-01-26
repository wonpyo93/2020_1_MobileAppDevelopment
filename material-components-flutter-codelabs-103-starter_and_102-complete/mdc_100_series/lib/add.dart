import 'package:Shrine/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';
import 'login.dart';
import 'home.dart';

class AddProductPage extends StatefulWidget {
  _AddProductPage createState() => _AddProductPage();
}

class _AddProductPage extends State<AddProductPage> {
  final defaultURL = "http://handong.edu/site/handong/res/img/logo.png";
  final databaseReference = Firestore.instance;
  String _uploadedFileURL;

  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final productDescription = TextEditingController();

  String tempID = Uuid().v1();
  
  var newImageLoaded = false;
  var _image;

  Widget showImage() {
    if(!newImageLoaded)
      {
        return Image.network(defaultURL, width: 300, height: 300);
      }
    else
      {
        return Image.file(_image, width: 300, height: 300);
      }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      newImageLoaded = true;
    });
  }

  Future uploadFile(String productName) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/$tempID');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  void createProduct(String tempName, String price, String description) async {
    debugPrint(theUid);
    await databaseReference.collection("products")
        .document(tempID)
        .setData({
      'ID' : tempID,
      'name': tempName,
      'price': int.parse(price),
      'image' : "images/$tempID",
      'description': description,
      'timeCreated': FieldValue.serverTimestamp(),
      'timeModify': FieldValue.serverTimestamp(),
      'creatorID' : theUid,
      'likes' : 0,
      'likedPeople' : []
    });
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
        title: Text('Add'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              createProduct(productName.text, productPrice.text, productDescription.text);
              uploadFile(productName.text);
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
              labelText: 'Product Name',
            ),
          ),
          SizedBox(height: 12.0),
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
              labelText: 'Price',
            ),
          ),
          SizedBox(height: 12.0),
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
              labelText: 'Description',
            ),
          ),
        ],
      ),
    );
  }
}