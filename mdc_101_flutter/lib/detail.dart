import 'package:flutter/material.dart';
import 'model/product.dart';
import 'dart:math' as math;
import 'home.dart';

class MyDetailPage extends StatefulWidget
{
   Product _product;
   MyDetailPage(Product product)
   {
     _product = product;
   }

   @override
  State<StatefulWidget> createState() {
     return MyDetailPageState(_product);
   }
}

class MyDetailPageState extends State<MyDetailPage>
{
  bool _isFavorited = false;
  int _favoriteCount = 0;
  Product _product;
  MyDetailPageState(Product product)
  {
    _product = product;
  }
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _product.category = Category.favoriteNo;
        _isFavorited = false;
        _product.isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
        _product.category = Category.favoriteYes;
        _product.isFavorited = true;

        print("_product.isFavorited is now true");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Hero(
                tag: _product.id,
                child: Image.asset(_product.assetName),
              ),
              Positioned(
                right: 10.0,
                child: IconButton(
                  icon: (_product.isFavorited ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
                  color: Colors.red[500],
                  onPressed: _toggleFavorite,
                  iconSize: 30.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 12.0, 25.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: Colors.yellow,
                      size: 30,
                    ),
                    child: StarDisplay(value: _product.star),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent,fontSize: 30),
                    textScaleFactor: 0.8,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8.0),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.location_on,
                          color: Colors.blueAccent,
                        ),
                        Text(
                          _product.address,
                          style: TextStyle(color: Colors.blue,fontSize: 20),
                          textScaleFactor: 0.8,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  SizedBox(height:8.0),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(Icons.phone,
                            color: Colors.blueAccent,
                            size: 20,),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          _product.phoneNum,
                          style: TextStyle(color: Colors.blue,fontSize: 20),
                          textScaleFactor: 0.8,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  SizedBox(height: 8.0),
                  Divider(color: Colors.grey),
                  Text(
                    _product.descriptions,
                    style: TextStyle(color: Colors.blue,fontSize: 18),
                    textScaleFactor: 0.8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({Key key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : null,
          color: Colors.yellow,
        );
      }),
    );
  }
}