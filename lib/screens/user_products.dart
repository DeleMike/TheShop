import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product.dart';

class UserProduct extends StatelessWidget {
  static const routeName = '/user-product';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true); //to filter per user
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, dataSnapshot) =>
            dataSnapshot.connectionState == ConnectionState.waiting
                ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)),
                )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (_, productsData, __) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) {
                            return Column(
                              children: [
                                UserProductItem(
                                    productsData.items[i].id,
                                    productsData.items[i].title,
                                    productsData.items[i].imageUrl),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
