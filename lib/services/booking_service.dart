
import 'package:flutter/material.dart';

class BookingService extends ChangeNotifier {
  BookingService._();

  static final BookingService instance = BookingService._();

  final List<Map<String, dynamic>> _bookings = [];

  List<Map<String, dynamic>> get bookings =>
      List.unmodifiable(_bookings);

  void addBooking({
    required Map<String, String> tour,
    required DateTime travelDate,
    required int travellers,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required int totalPrice,
  }) {
    _bookings.insert(0, {
      'tour': Map<String, String>.from(tour),
      'travelDate': travelDate,
      'travellers': travellers,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'totalPrice': totalPrice,
      'bookingDate': DateTime.now(),
      'status': 'Confirmed',
    });

    notifyListeners();
  }
}
