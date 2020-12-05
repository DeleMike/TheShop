import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/cart_item.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  final String authToken;

  Orders(this.authToken, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://the--shop.firebaseio.com/orders.json?auth=$authToken';

    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        Order(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://the--shop.firebaseio.com/orders.json?auth=$authToken';

    final response = await http.get(url);
    final List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(Order(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList()));
    });

    _orders = loadedOrders.reversed.toList(); //to place recent order at the top
    notifyListeners();
  }
}
