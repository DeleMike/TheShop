import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Center(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Shop',
                      style: TextStyle(
                          fontFamily: 'Anto',
                          fontSize: 28,
                          fontWeight: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .fontWeight,
                          fontStyle: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .fontStyle,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color)),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Colors.black,
            ),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
              color: Colors.black,
            ),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Colors.black,
            ),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProduct.routeName);
            },
          ),
        ],
      ),
    );
  }
}
