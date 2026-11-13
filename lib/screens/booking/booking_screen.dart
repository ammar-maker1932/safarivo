
import 'package:flutter/material.dart';
import 'booking_confirmation_screen.dart';
import '../../services/booking_service.dart';

const Color bookingPrimary = Color(0xFF102C35);
const Color bookingAccent = Color(0xFF18A999);
const Color bookingBackground = Color(0xFFF7F7F2);
const Color bookingMuted = Color(0xFF778387);

class BookingScreen extends StatefulWidget {
  final Map<String, String> tour;

  const BookingScreen({
    super.key,
    required this.tour,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  DateTime? selectedDate;
  int travellers = 1;

  int get pricePerPerson {
    return int.parse(
      widget.tour['price']!.replaceAll(RegExp(r'[^0-9]'), ''),
    );
  }

  int get totalPrice => pricePerPerson * travellers;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String formatPrice(int price) {
    return 'Rs. ${price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
    )}';
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: bookingPrimary,
              secondary: bookingAccent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }


  void _continueBooking() {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your travel date.'),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    BookingService.instance.addBooking(
      tour: widget.tour,
      travelDate: selectedDate!,
      travellers: travellers,
      customerName: _nameController.text.trim(),
      customerEmail: _emailController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      totalPrice: totalPrice,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(
          tour: widget.tour,
          travelDate: selectedDate!,
          travellers: travellers,
          customerName: _nameController.text.trim(),
          customerEmail: _emailController.text.trim(),
          customerPhone: _phoneController.text.trim(),
          totalPrice: totalPrice,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final tour = widget.tour;

    return Scaffold(
      backgroundColor: bookingBackground,
      appBar: AppBar(
        backgroundColor: bookingBackground,
        foregroundColor: bookingPrimary,
        elevation: 0,
        title: const Text(
          'Complete Your Booking',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Your Tour'),
                  const SizedBox(height: 14),
                  _tourSummary(tour),

                  const SizedBox(height: 28),
                  _sectionTitle('Travel Details'),
                  const SizedBox(height: 14),
                  _dateSelector(),

                  const SizedBox(height: 18),
                  _travellerSelector(),

                  const SizedBox(height: 28),
                  _sectionTitle('Personal Information'),
                  const SizedBox(height: 14),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _textField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _textField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                !RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(value.trim())) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _textField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: '03XX XXXXXXX',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null ||
                                value.trim().length < 10) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  _sectionTitle('Price Summary'),
                  const SizedBox(height: 14),
                  _priceSummary(),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: _continueBooking,
                      style: FilledButton.styleFrom(
                        backgroundColor: bookingPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'No payment will be collected at this stage.',
                      style: TextStyle(
                        color: bookingMuted,
                        fontSize: 12,
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: bookingPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _tourSummary(Map<String, String> tour) {
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
              tour['image']!,
              width: 105,
              height: 105,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 105,
                  height: 105,
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
                  tour['name']!,
                  style: const TextStyle(
                    color: bookingPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tour['location']!,
                  style: const TextStyle(
                    color: bookingMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tour['duration']!,
                  style: const TextStyle(
                    color: bookingPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${tour['price']} / person',
                  style: const TextStyle(
                    color: bookingAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Travel Date',
          style: TextStyle(
            color: bookingPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: bookingAccent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Select your travel date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    style: TextStyle(
                      color: selectedDate == null
                          ? bookingMuted
                          : bookingPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: bookingMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _travellerSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travellers',
                  style: TextStyle(
                    color: bookingPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Number of people',
                  style: TextStyle(
                    color: bookingMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: travellers > 1
                ? () => setState(() => travellers--)
                : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: bookingAccent,
          ),
          Text(
            '$travellers',
            style: const TextStyle(
              color: bookingPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          IconButton(
            onPressed: travellers < 20
                ? () => setState(() => travellers++)
                : null,
            icon: const Icon(Icons.add_circle_outline),
            color: bookingAccent,
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: bookingPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: bookingMuted, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: bookingAccent,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _priceSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _priceRow(
            'Price per person',
            formatPrice(pricePerPerson),
          ),
          const SizedBox(height: 12),
          _priceRow(
            'Travellers',
            '$travellers',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          _priceRow(
            'Estimated Total',
            formatPrice(totalPrice),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
      String title,
      String value, {
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? bookingPrimary : bookingMuted,
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? bookingAccent : bookingPrimary,
            fontSize: isTotal ? 17 : 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
