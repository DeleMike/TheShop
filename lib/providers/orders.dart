import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../models/cart_item.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(0, Order(id: DateTime.now().toString(), amount: total, products: cartProducts, dateTime: DateTime.now()));   
    notifyListeners();
  }

}