
import 'package:flutter/material.dart';
import '../../services/booking_service.dart';

const Color myBookingPrimary = Color(0xFF102C35);
const Color myBookingAccent = Color(0xFF18A999);
const Color myBookingBackground = Color(0xFFF7F7F2);
const Color myBookingMuted = Color(0xFF778387);

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int selectedTab = 0;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatPrice(int price) {
    return 'Rs. ${price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: BookingService.instance,
        builder: (context, child) {
          final allBookings = BookingService.instance.bookings;
          final now = DateTime.now();

          final filteredBookings = allBookings.where((booking) {
            final date = booking['travelDate'] as DateTime;
            final isUpcoming = !DateUtils.dateOnly(date)
                .isBefore(DateUtils.dateOnly(now));

            return selectedTab == 0 ? isUpcoming : !isUpcoming;
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Bookings',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: myBookingPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Keep track of your travel plans.',
                      style: TextStyle(
                        fontSize: 13,
                        color: myBookingMuted,
                      ),
                    ),
                    const SizedBox(height: 25),

                    _buildTabs(),

                    const SizedBox(height: 22),

                    if (filteredBookings.isEmpty)
                      _buildEmptyState()
                    else
                      ...filteredBookings.map(_buildBookingCard),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _tabButton('Upcoming', 0),
          _tabButton('Past', 1),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? myBookingPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : myBookingMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isUpcoming = selectedTab == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF4EF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUpcoming
                  ? Icons.luggage_outlined
                  : Icons.history_rounded,
              size: 35,
              color: myBookingPrimary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            isUpcoming ? 'No upcoming trips' : 'No past trips yet',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: myBookingPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isUpcoming
                ? 'Your upcoming bookings will appear here.'
                : 'Your completed travel history will appear here.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: myBookingMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final tour = Map<String, String>.from(booking['tour']);
    final travelDate = booking['travelDate'] as DateTime;
    final travellers = booking['travellers'] as int;
    final totalPrice = booking['totalPrice'] as int;

    final isUpcoming = !DateUtils.dateOnly(travelDate)
        .isBefore(DateUtils.dateOnly(DateTime.now()));

    return Container(
      margin: const EdgeInsets.only(bottom: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Image.network(
              tour['image'] ?? '',
              height: 175,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 175,
                  color: const Color(0xFFDDECE5),
                  child: const Icon(
                    Icons.landscape_outlined,
                    size: 45,
                    color: myBookingPrimary,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tour['name'] ?? 'Tour',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: myBookingPrimary,
                        ),
                      ),
                    ),
                    _statusBadge(isUpcoming),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  tour['location'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: myBookingMuted,
                  ),
                ),
                const SizedBox(height: 17),
                _detailRow(
                  Icons.calendar_today_outlined,
                  'Travel date',
                  _formatDate(travelDate),
                ),
                const SizedBox(height: 11),
                _detailRow(
                  Icons.people_outline_rounded,
                  'Travellers',
                  '$travellers ${travellers == 1 ? 'person' : 'people'}',
                ),
                const SizedBox(height: 11),
                _detailRow(
                  Icons.schedule_rounded,
                  'Duration',
                  tour['duration'] ?? 'Not available',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(height: 1, color: Color(0xFFF0F1ED)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total amount',
                      style: TextStyle(
                        fontSize: 13,
                        color: myBookingMuted,
                      ),
                    ),
                    Text(
                      _formatPrice(totalPrice),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: myBookingAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isUpcoming) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isUpcoming
            ? const Color(0xFFEAF4EF)
            : const Color(0xFFF0F1ED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isUpcoming ? 'Confirmed' : 'Completed',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isUpcoming ? myBookingAccent : myBookingMuted,
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 17, color: myBookingAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: myBookingMuted,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: myBookingPrimary,
          ),
        ),
      ],
    );
  }
}
