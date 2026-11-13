
import 'package:flutter/material.dart';

class WishlistService extends ChangeNotifier {
  WishlistService._();

  static final WishlistService instance = WishlistService._();

  final List<Map<String, String>> _items = [];

  List<Map<String, String>> get items => List.unmodifiable(_items);

  bool isSaved(Map<String, String> tour) {
    return _items.any((item) => item['name'] == tour['name']);
  }

  void toggleWishlist(Map<String, String> tour) {
    if (isSaved(tour)) {
      _items.removeWhere((item) => item['name'] == tour['name']);
    } else {
      _items.add(Map<String, String>.from(tour));
    }

    notifyListeners();
  }

  void removeTour(Map<String, String> tour) {
    _items.removeWhere((item) => item['name'] == tour['name']);
    notifyListeners();
  }
}
