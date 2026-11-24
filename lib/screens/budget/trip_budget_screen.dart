
import 'package:flutter/material.dart';
import '../../services/budget_prediction_service.dart';

class TripBudgetScreen extends StatefulWidget {
  const TripBudgetScreen({super.key});

  @override
  State<TripBudgetScreen> createState() => _TripBudgetScreenState();
}

class _TripBudgetScreenState extends State<TripBudgetScreen> {
  final BudgetPredictionService _budgetService =
  BudgetPredictionService();

  static const Color primary = Color(0xFF102C35);
  static const Color accent = Color(0xFF18A999);
  static const Color background = Color(0xFFF7F7F2);
  static const Color muted = Color(0xFF778387);

  String destination = 'Hunza';
  String accommodation = 'Standard';

  int days = 3;
  int travellers = 2;

  bool isLoading = true;
  bool isPredicting = false;

  TripBudgetPrediction? prediction;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAIModel();
  }

  Future<void> _loadAIModel() async {
    try {
      await _budgetService.loadModel();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Unable to load AI model: $e';
      });
    }
  }

  void _estimateBudget() {
    if (isLoading || isPredicting) return;

    setState(() {
      isPredicting = true;
      prediction = null;
      errorMessage = null;
    });

    try {
      final result = _budgetService.predictBudget(
        destination: destination,
        days: days,
        travellers: travellers,
        accommodation: accommodation,
      );

      setState(() {
        prediction = result;
        isPredicting = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Prediction failed: $e';
        isPredicting = false;
      });
    }
  }

  void _clearPrediction() {
    prediction = null;
    errorMessage = null;
  }

  String _formatPKR(double amount) {
    final value = amount.round().toString();

    return value.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
    );
  }

  @override
  void dispose() {
    _budgetService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'AI Trip Budget',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 19,
            color: primary,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: accent,
        ),
      )
          : errorMessage != null && prediction == null
          ? _buildErrorScreen()
          : SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),

            const SizedBox(height: 26),

            _buildSectionHeading(
              'Plan your journey',
              'Customize your trip details',
            ),

            const SizedBox(height: 16),

            _buildTripDetailsCard(),

            const SizedBox(height: 22),

            _buildSectionHeading(
              'Accommodation',
              'Choose your comfort level',
            ),

            const SizedBox(height: 14),

            _buildAccommodationSelector(),

            const SizedBox(height: 26),

            _buildEstimateButton(),

            if (prediction != null) ...[
              const SizedBox(height: 30),
              _buildResultSection(),
            ],

            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildInlineError(),
            ],
          ],
        ),
      ),
    );
  }

  // Hero section
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.travel_explore_rounded,
              size: 110,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFF50D6BF),
                      size: 15,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'POWERED BY SAFARIVO AI',
                      style: TextStyle(
                        color: Color(0xFF50D6BF),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Travel smarter.\nSpend better.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Plan your expenses before you pack your bags.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section heading
  Widget _buildSectionHeading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: muted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Trip details card
  Widget _buildTripDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEAEDE9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Destination'),

          DropdownButtonFormField<String>(
            value: destination,
            isExpanded: true,
            decoration: _inputDecoration(
              Icons.location_on_outlined,
            ),
            items: [
              'Hunza',
              'Skardu',
              'Naran',
              'Murree',
              'Swat',
            ].map((place) {
              return DropdownMenuItem(
                value: place,
                child: Text(place),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                destination = value;
                _clearPrediction();
              });
            },
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _buildCounter(
                  title: 'Trip duration',
                  subtitle: 'Days',
                  value: days,
                  icon: Icons.calendar_month_outlined,
                  onDecrease: () {
                    if (days > 1) {
                      setState(() {
                        days--;
                        _clearPrediction();
                      });
                    }
                  },
                  onIncrease: () {
                    if (days < 10) {
                      setState(() {
                        days++;
                        _clearPrediction();
                      });
                    }
                  },
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _buildCounter(
                  title: 'Travellers',
                  subtitle: 'People',
                  value: travellers,
                  icon: Icons.people_outline_rounded,
                  onDecrease: () {
                    if (travellers > 1) {
                      setState(() {
                        travellers--;
                        _clearPrediction();
                      });
                    }
                  },
                  onIncrease: () {
                    if (travellers < 8) {
                      setState(() {
                        travellers++;
                        _clearPrediction();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Counter widget
  Widget _buildCounter({
    required String title,
    required String subtitle,
    required int value,
    required IconData icon,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 18),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _counterButton(
                icon: Icons.remove_rounded,
                onTap: onDecrease,
              ),

              Column(
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(
                      color: primary,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),

              _counterButton(
                icon: Icons.add_rounded,
                onTap: onIncrease,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            icon,
            size: 18,
            color: primary,
          ),
        ),
      ),
    );
  }

  // Accommodation selector
  Widget _buildAccommodationSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildAccommodationOption(
            title: 'Budget',
            subtitle: 'Affordable',
            icon: Icons.savings_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildAccommodationOption(
            title: 'Standard',
            subtitle: 'Balanced',
            icon: Icons.hotel_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildAccommodationOption(
            title: 'Luxury',
            subtitle: 'Premium',
            icon: Icons.king_bed_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildAccommodationOption({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = accommodation == title;

    return Material(
      color: isSelected ? primary : Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          setState(() {
            accommodation = title;
            _clearPrediction();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? primary : const Color(0xFFE6EAE6),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? accent : muted,
                size: 23,
              ),

              const SizedBox(height: 9),

              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: TextStyle(
                  color: isSelected ? Colors.white70 : muted,
                  fontSize: 9,
                ),
              ),

              const SizedBox(height: 8),

              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                color: isSelected ? accent : const Color(0xFFD5DBD7),
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Estimate button
  Widget _buildEstimateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isPredicting ? null : _estimateBudget,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          disabledBackgroundColor: accent.withOpacity(0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isPredicting
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_rounded, size: 19),
            SizedBox(width: 10),
            Text(
              'Estimate My Trip Budget',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Result section
  Widget _buildResultSection() {
    final result = prediction!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(
          'Your trip estimate',
          'AI-generated breakdown of your expenses',
        ),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF50D6BF),
                    size: 19,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'TOTAL ESTIMATED BUDGET',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              Text(
                'PKR ${_formatPKR(result.total)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF50D6BF),
                      size: 20,
                    ),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Text(
                        'Estimated per person',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      'PKR ${_formatPKR(result.perPerson(travellers))}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFEAEDE9),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expense breakdown',
                style: TextStyle(
                  color: primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Where your estimated budget goes',
                style: TextStyle(
                  color: muted,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 22),

              _buildExpenseRow(
                title: 'Transportation',
                amount: result.transportation,
                total: result.total,
                icon: Icons.directions_car_outlined,
              ),

              const SizedBox(height: 21),

              _buildExpenseRow(
                title: 'Accommodation',
                amount: result.accommodation,
                total: result.total,
                icon: Icons.hotel_outlined,
              ),

              const SizedBox(height: 21),

              _buildExpenseRow(
                title: 'Food',
                amount: result.food,
                total: result.total,
                icon: Icons.restaurant_outlined,
              ),

              const SizedBox(height: 21),

              _buildExpenseRow(
                title: 'Other expenses',
                amount: result.otherExpenses,
                total: result.total,
                icon: Icons.receipt_long_outlined,
              ),

              const Divider(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'PKR ${_formatPKR(result.total)}',
                    style: const TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: primary,
                size: 18,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'This is an illustrative AI estimate based on '
                      'synthetic training data, not a confirmed market price.',
                  style: TextStyle(
                    color: primary,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Individual expense row
  Widget _buildExpenseRow({
    required String title,
    required double amount,
    required double total,
    required IconData icon,
  }) {
    final progress = total > 0
        ? (amount / total).clamp(0.0, 1.0).toDouble()
        : 0.0;

    final percentage = progress * 100;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                icon,
                color: accent,
                size: 19,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'PKR ${_formatPKR(amount)}',
                  style: const TextStyle(
                    color: primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFFEDF0ED),
            valueColor: const AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
      ],
    );
  }

  // Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: const TextStyle(
          color: primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // Input decoration
  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: accent,
        size: 20,
      ),
      filled: true,
      fillColor: background,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEAEDE9),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: accent,
          width: 1.3,
        ),
      ),
    );
  }

  Widget _buildInlineError() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 42,
            ),
            const SizedBox(height: 14),
            const Text(
              'AI model could not be loaded',
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Please try again.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: muted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
