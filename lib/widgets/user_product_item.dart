import 'package:flutter/material.dart';

import '../screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  UserProductItem(this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      splashColor: Theme.of(context).accentColor.withOpacity(0.2),
          child: ListTile(
          title: Text(title),
          leading: CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Container(
      width: 100,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
            color: Theme.of(context).errorColor,
          ),
        ],
      ),
          ),
        ),
    );
  }
}
