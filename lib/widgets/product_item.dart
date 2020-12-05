import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../screens/product_detail.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final productData = Provider.of<Products>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetail.routeName, arguments: _product.id);
            },
            child: Image.network(
              _product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (_, product, __) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  var val = product.toggleFavoriteStatus();
                  productData.updateFavoriteStatus(_product.id, _product, val, authData.userId);
                },
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(_product.id, _product.price, _product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added item to cart!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(_product.id);
                      },
                    ),
                  ),
                );
              },
            ),
            title: Text(
              _product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
