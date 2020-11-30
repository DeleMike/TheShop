import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  //returns no of product in cart
  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach(
        (key, cartItem) => total += (cartItem.price * cartItem.quantity));

    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();

  }

  void clear() {
    _items  = {};
    notifyListeners();
  }

  //add item to cart if it does not exist or add an extra quantity if it exist
  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }

    notifyListeners();
  }
}
