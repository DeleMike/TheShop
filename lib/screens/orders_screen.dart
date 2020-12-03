import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';
import '../widgets/loading.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else if (dataSnapShot.error != null) {
              //DO Error handling task
              return Center(
                child: Text(
                    'An error occured while fetching data...please pull screen to refresh'),
              );
            } else {
              return Consumer<Orders>(
                builder: (_, ordersData, __) => ListView.builder(
                  itemBuilder: (ctx, index) {
                    return OrderItem(ordersData.orders[index]);
                  },
                  itemCount: ordersData.orders.length,
                ),
              );
            }
          }),
      drawer: AppDrawer(),
    );
  }
}
