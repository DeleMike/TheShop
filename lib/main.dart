import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview.dart';
import './screens/product_detail.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/user_products.dart';
import './screens/edit_product.dart';
import './screens/auth_screen.dart';
import './screens/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
         ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        initialRoute : '/',
        routes: {
          '/' : (context) => AuthScreen(),
          ProductsOverview.routeName : (context) => ProductsOverview(),
          ProductDetail.routeName: (context) => ProductDetail(),
          CartScreen.routeName : (context) => CartScreen(),
          OrdersScreen.routeName : (context) => OrdersScreen(),
          UserProduct.routeName : (context) => UserProduct(),
          EditProduct.routeName : (context) => EditProduct(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
