import 'package:flutter/cupertino.dart';
import 'model/product.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class MyFavoritePage extends StatefulWidget
{
  List<Product> _products;
  MyFavoritePage(List<Product> products)
  {
    _products = products;
  }
  @override
  State<StatefulWidget> createState() {
    return MyFavoritePageState(_products);

  }
}

class MyFavoritePageState extends State<MyFavoritePage> {

  List<Product> _products = List<Product>();
  List<Product> _productsFav = List<Product>();

  int favNum = 0;
  MyFavoritePageState(List<Product> products)
  {
    _products = products;

    for(int i = 0 ; i < _products.length; i++)
    {
      print(_products[i].isFavorited);
      if(_products[i].isFavorited == true)
      {
        _productsFav.add(_products[i]);
        favNum++;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Hotels'),
      ),
      body: ListView.builder(
        itemCount: _productsFav.length,
        itemBuilder: (context, index) {
          final item = _productsFav[index];
          return Dismissible(
            key: Key(item.name),
            onDismissed: (direction) {
              setState(() {
                _productsFav[index].isFavorited = false;
                _productsFav.removeAt(index);
              });
            },
            background: Container(color: Colors.red),
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 15),
              title: Text(
                  _productsFav[index].name
              ),
            ),
          );
        },
      ),
    );
  }
}
