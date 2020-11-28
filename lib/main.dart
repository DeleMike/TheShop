import 'package:flutter/material.dart';

import './screens/products_overview.dart';
import './screens/product_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home: ProductsOverview(),
      routes: {
        ProductDetail.routeName : (context) => ProductDetail(),
      },
    );
  }
}