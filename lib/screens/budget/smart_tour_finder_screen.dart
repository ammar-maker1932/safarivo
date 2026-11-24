
import 'package:flutter/material.dart';

import '../../data/tour_data.dart';
import '../tours/tour_details_screen.dart';

const Color finderPrimary = Color(0xFF102C35);
const Color finderAccent = Color(0xFF18A999);
const Color finderBackground = Color(0xFFF7F7F2);
const Color finderMuted = Color(0xFF778387);

class SmartTourFinderScreen extends StatefulWidget {
  const SmartTourFinderScreen({super.key});

  @override
  State<SmartTourFinderScreen> createState() =>
      _SmartTourFinderScreenState();
}

class _SmartTourFinderScreenState
    extends State<SmartTourFinderScreen> {
  final budgetController = TextEditingController();

  int travellers = 2;

  final List<String> interests = [
    'Mountains',
    'Nature',
    'Adventure',
    'Lakes',
    'Hiking',
    'Camping',
    'Photography',
    'Relaxation',
  ];

  final Set<String> selectedInterests = {};

  List<Map<String, String>> recommendedTours = [];

  bool hasSearched = false;

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  void findTours() {
    final budget = double.tryParse(
      budgetController.text.trim().replaceAll(',', ''),
    );

    if (budget == null || budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid budget.'),
        ),
      );
      return;
    }

    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one interest.'),
        ),
      );
      return;
    }

    final matchingTours = safarivoTours.where((tour) {
      final price = double.parse(tour['pricePerPerson']!);
      final totalPrice = price * travellers;

      return totalPrice <= budget;
    }).toList();

    matchingTours.sort((a, b) {
      final aInterests = a['interests']!.split(',');
      final bInterests = b['interests']!.split(',');

      final aMatches = selectedInterests
          .where((interest) => aInterests.contains(interest))
          .length;

      final bMatches = selectedInterests
          .where((interest) => bInterests.contains(interest))
          .length;

      return bMatches.compareTo(aMatches);
    });

    setState(() {
      recommendedTours = matchingTours;
      hasSearched = true;
    });
  }

  String formatPrice(double price) {
    final value = price.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(value[i]);
    }

    return 'Rs. ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: finderBackground,
      appBar: AppBar(
        backgroundColor: finderBackground,
        foregroundColor: finderPrimary,
        elevation: 0,
        title: const Text(
          'Smart Tour Finder',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(),
              const SizedBox(height: 25),
              _buildBudgetField(),
              const SizedBox(height: 22),
              _buildTravellersSelector(),
              const SizedBox(height: 25),
              _buildInterestsSection(),
              const SizedBox(height: 25),
              _buildFindButton(),
              if (hasSearched) ...[
                const SizedBox(height: 32),
                _buildResults(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: finderPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: finderAccent,
                size: 19,
              ),
              const SizedBox(width: 8),
              Text(
                'SAFARIVO INTELLIGENCE',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Your interests.\nYour budget. Your journey.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1.2,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Discover tours that match the way you love to travel.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your total budget?',
          style: TextStyle(
            color: finderPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: budgetController,
          keyboardType: TextInputType.number,
          onChanged: (_) {
            if (hasSearched) {
              setState(() {
                hasSearched = false;
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'e.g. 50000',
            prefixText: 'PKR  ',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: Color(0xFFE8ECE9),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: Color(0xFFE8ECE9),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: finderAccent,
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Enter the total budget for all travellers.',
          style: TextStyle(
            color: finderMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildTravellersSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How many people are travelling?',
          style: TextStyle(
            color: finderPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: const Color(0xFFE8ECE9),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.people_alt_outlined,
                color: finderAccent,
                size: 23,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Travellers',
                  style: TextStyle(
                    color: finderPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _counterButton(
                Icons.remove,
                    () {
                  if (travellers > 1) {
                    setState(() {
                      travellers--;
                      hasSearched = false;
                    });
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$travellers',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: finderPrimary,
                  ),
                ),
              ),
              _counterButton(
                Icons.add,
                    () {
                  if (travellers < 20) {
                    setState(() {
                      travellers++;
                      hasSearched = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _counterButton(
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4F0),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          color: finderPrimary,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What do you love?',
          style: TextStyle(
            color: finderPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Select all the experiences you enjoy.',
          style: TextStyle(
            color: finderMuted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 9,
          runSpacing: 10,
          children: interests.map((interest) {
            final selected =
            selectedInterests.contains(interest);

            return FilterChip(
              label: Text(interest),
              selected: selected,
              onSelected: (value) {
                setState(() {
                  if (value) {
                    selectedInterests.add(interest);
                  } else {
                    selectedInterests.remove(interest);
                  }
                  hasSearched = false;
                });
              },
              selectedColor: const Color(0xFFDCEFE9),
              backgroundColor: Colors.white,
              checkmarkColor: finderAccent,
              labelStyle: TextStyle(
                color: selected
                    ? finderPrimary
                    : finderMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: selected
                      ? finderAccent
                      : const Color(0xFFE8ECE9),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFindButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: findTours,
        style: ElevatedButton.styleFrom(
          backgroundColor: finderAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_rounded, size: 19),
            SizedBox(width: 9),
            Text(
              'Find My Best Tour',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (recommendedTours.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 35,
              color: finderMuted,
            ),
            SizedBox(height: 10),
            Text(
              'No matching tours found',
              style: TextStyle(
                color: finderPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Try increasing your budget or selecting different interests.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: finderMuted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    final budget = double.parse(
      budgetController.text.trim().replaceAll(',', ''),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your recommended tours',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: finderPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${recommendedTours.length} tours match your budget.',
          style: const TextStyle(
            color: finderMuted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 17),
        ...List.generate(
          recommendedTours.length,
              (index) {
            final tour = recommendedTours[index];

            final price =
            double.parse(tour['pricePerPerson']!);

            final totalPrice = price * travellers;

            final matchedInterests =
            tour['interests']!.split(',')
                .where(
                  (interest) =>
                  selectedInterests.contains(interest),
            )
                .toList();

            final isBestMatch = index == 0;

            return _buildRecommendationCard(
              tour: tour,
              totalPrice: totalPrice,
              budget: budget,
              matchedInterests: matchedInterests,
              isBestMatch: isBestMatch,
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommendationCard({
    required Map<String, String> tour,
    required double totalPrice,
    required double budget,
    required List<String> matchedInterests,
    required bool isBestMatch,
  }) {
    final remaining = budget - totalPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: isBestMatch
              ? finderAccent
              : const Color(0xFFE8ECE9),
          width: isBestMatch ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  tour['image']!,
                  height: 165,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 165,
                    color: const Color(0xFFDDECE5),
                    child: const Icon(
                      Icons.landscape_rounded,
                      color: finderAccent,
                      size: 40,
                    ),
                  ),
                ),
              ),
              if (isBestMatch)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: finderAccent,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Text(
                      'BEST MATCH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour['name']!,
                  style: const TextStyle(
                    color: finderPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tour['location']!,
                  style: const TextStyle(
                    color: finderMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 15,
                      color: finderAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tour['duration']!,
                      style: const TextStyle(
                        color: finderMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(color: Color(0xFFE8ECE9)),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total package cost',
                        style: TextStyle(
                          color: finderMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      formatPrice(totalPrice),
                      style: const TextStyle(
                        color: finderPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatPrice(totalPrice / travellers)} per person',
                  style: const TextStyle(
                    color: finderMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: finderAccent,
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${formatPrice(remaining)} remaining in your budget',
                        style: const TextStyle(
                          color: finderMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Matched interests',
                  style: TextStyle(
                    color: finderPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: matchedInterests.map((interest) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        interest,
                        style: const TextStyle(
                          color: finderPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TourDetailsScreen(tour: tour),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: finderPrimary,
                      side: const BorderSide(
                        color: finderPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'View Tour Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
