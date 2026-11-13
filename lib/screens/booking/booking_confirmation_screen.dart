
import 'package:flutter/material.dart';

const Color confirmationPrimary = Color(0xFF102C35);
const Color confirmationAccent = Color(0xFF18A999);
const Color confirmationBackground = Color(0xFFF7F7F2);
const Color confirmationMuted = Color(0xFF778387);

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, String> tour;
  final DateTime travelDate;
  final int travellers;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final int totalPrice;

  const BookingConfirmationScreen({
    super.key,
    required this.tour,
    required this.travelDate,
    required this.travellers,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.totalPrice,
  });

  String get formattedDate {
    return '${travelDate.day}/${travelDate.month}/${travelDate.year}';
  }

  String formatPrice(int price) {
    return 'Rs. ${price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: confirmationBackground,
      appBar: AppBar(
        backgroundColor: confirmationBackground,
        foregroundColor: confirmationPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Booking Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _successHeader(),
                  const SizedBox(height: 28),

                  _sectionTitle('Tour Details'),
                  const SizedBox(height: 12),
                  _tourCard(),

                  const SizedBox(height: 24),
                  _sectionTitle('Travel Information'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _infoRow('Travel date', formattedDate),
                    _infoRow('Travellers', '$travellers'),
                    _infoRow('Duration', tour['duration'] ?? 'Not available'),
                  ]),

                  const SizedBox(height: 24),
                  _sectionTitle('Contact Information'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _infoRow('Full name', customerName),
                    _infoRow('Email', customerEmail),
                    _infoRow('Phone', customerPhone),
                  ]),

                  const SizedBox(height: 24),
                  _sectionTitle('Price Summary'),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                          'Price per person',
                          formatPrice(
                            totalPrice ~/ travellers,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _infoRow('Travellers', '$travellers'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Divider(height: 1),
                        ),
                        _infoRow(
                          'Estimated total',
                          formatPrice(totalPrice),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: confirmationAccent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: confirmationAccent,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'This is a demo booking summary. Your reservation has not been submitted to a tour operator, and no payment has been made.',
                            style: TextStyle(
                              color: confirmationPrimary,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.popUntil(
                          context,
                              (route) => route.isFirst,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: confirmationPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Back to App',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _successHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: confirmationAccent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: confirmationAccent,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Booking Summary',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: confirmationPrimary,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Review the details you entered below.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: confirmationMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: confirmationPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _tourCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              tour['image'] ?? '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.black12,
                  child: const Icon(Icons.landscape_outlined),
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour['name'] ?? 'Tour',
                  style: const TextStyle(
                    color: confirmationPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tour['location'] ?? '',
                  style: const TextStyle(
                    color: confirmationMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tour['category'] ?? '',
                  style: const TextStyle(
                    color: confirmationAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: rows,
      ),
    );
  }

  Widget _infoRow(
      String label,
      String value, {
        bool isTotal = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isTotal ? confirmationPrimary : confirmationMuted,
                fontSize: isTotal ? 15 : 13,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isTotal ? confirmationAccent : confirmationPrimary,
                fontSize: isTotal ? 17 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
