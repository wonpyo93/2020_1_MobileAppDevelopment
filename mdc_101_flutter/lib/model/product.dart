import 'package:flutter/foundation.dart';

enum Category { all, favoriteYes, favoriteNo}

class Product {
   Category category;
   int id;
   String name;
   int star;
   String address;
   String phoneNum;
   String descriptions;
   bool isFavorited;

   Product({
    this.category,
    this.id,
    this.name,
    this.star,
    this.address,
    this.phoneNum,
    this.descriptions,
    this.isFavorited,
  });

  String get assetName => 'assets/hotel-$id.jpg';
  String get assetPackage => '.../assets/';

  @override
  String toString() => "$name (id=$id)";
}
