import 'package:flutter/cupertino.dart';
import 'model/product.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'detail.dart';

class MyPage extends StatefulWidget
{
  List<Product> _products;
  MyPage(List<Product> products)
  {
    _products = products;
  }
  @override
  State<StatefulWidget> createState() {
    return MyPageState(_products);

  }
}

class MyPageState extends State<MyPage> {

  List<Product> _products = List<Product>();
  List<Product> _productsFav = List<Product>();
  int _current = 0;

  int favNum = 0;
  MyPageState(List<Product> products)
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CarouselSlider(
              height: 300,
              initialPage: 0,
              enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              items: _productsFav.map((imageAddress) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            child: Image.asset(
                              imageAddress.assetName,
                              fit: BoxFit.fill,
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => MyDetailPage(imageAddress)));
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                imageAddress.name,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      )
    );
  }
}
