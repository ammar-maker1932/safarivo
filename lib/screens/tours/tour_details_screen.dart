
import 'package:flutter/material.dart';
import '../booking/booking_screen.dart';
import '../../services/wishlist_service.dart';

const Color detailPrimary = Color(0xFF102C35);
const Color detailAccent = Color(0xFF18A999);
const Color detailBackground = Color(0xFFF7F7F2);
const Color detailMuted = Color(0xFF778387);

class TourDetailsScreen extends StatefulWidget {
  final Map<String, String> tour;

  const TourDetailsScreen({
    super.key,
    required this.tour,
  });

  @override
  State<TourDetailsScreen> createState() => _TourDetailsScreenState();
}

class _TourDetailsScreenState extends State<TourDetailsScreen> {

  Map<String, String> get tour => widget.tour;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: detailBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHero(context),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 22),
                    _buildQuickInfo(),
                    const SizedBox(height: 30),
                    _buildSectionHeading('About this journey'),
                    const SizedBox(height: 10),
                    const Text(
                      'Experience the incredible landscapes of '
                          'Northern Pakistan. Discover beautiful valleys, '
                          'local culture, mountain views and unforgettable '
                          'moments throughout your journey.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.8,
                        color: detailMuted,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildSectionHeading('Your itinerary'),
                    const SizedBox(height: 16),
                    _buildItinerary(),
                    const SizedBox(height: 30),
                    _buildSectionHeading('What is included'),
                    const SizedBox(height: 14),
                    _buildIncluded(),
                    const SizedBox(height: 30),
                    _buildSectionHeading('Important information'),
                    const SizedBox(height: 10),
                    const Text(
                      'Prices and itinerary shown here are sample '
                          'information for this app prototype. Actual '
                          'availability and operator details will be '
                          'added later.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.6,
                        color: detailMuted,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBookingBar(context),
    );
  }

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      height: 310,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            tour['image']!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFDDECE5),
                child: const Icon(
                  Icons.landscape_rounded,
                  size: 70,
                  color: detailAccent,
                ),
              );
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 16,
            child: _heroButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 14,
            right: 16,
            child: AnimatedBuilder(
              animation: WishlistService.instance,
              builder: (context, child) {
                final isSaved =
                WishlistService.instance.isSaved(widget.tour);

                return _heroButton(
                  icon: isSaved
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  onTap: () {
                    WishlistService.instance.toggleWishlist(widget.tour);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSaved
                              ? 'Removed from wishlist'
                              : 'Added to wishlist',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 24,
            left: 22,
            right: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CURATED EXPERIENCE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tour['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: detailPrimary, size: 21),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: detailAccent,
              size: 18,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                tour['location']!,
                style: const TextStyle(
                  color: detailMuted,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          tour['price']!,
          style: const TextStyle(
            color: detailPrimary,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Sample price per person',
          style: TextStyle(
            color: detailMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: _infoItem(
              Icons.calendar_month_outlined,
              'Duration',
              tour['duration']!,
            ),
          ),
          Container(
            width: 1,
            height: 38,
            color: const Color(0xFFE8ECE9),
          ),
          Expanded(
            child: _infoItem(
              Icons.terrain_outlined,
              'Experience',
              tour['category']!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Icon(icon, color: detailAccent, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: detailMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: detailPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: detailPrimary,
      ),
    );
  }

  Widget _buildItinerary() {
    final days = [
      {
        'day': 'Day 01',
        'title': 'Arrival and exploration',
        'description':
        'Meet your travel group, settle in and explore the local area.',
      },
      {
        'day': 'Day 02',
        'title': 'Discover the landscapes',
        'description':
        'Enjoy scenic viewpoints, photography and local experiences.',
      },
      {
        'day': 'Day 03',
        'title': 'Adventure and culture',
        'description':
        'Explore nearby attractions and experience local traditions.',
      },
      {
        'day': 'Day 04',
        'title': 'Return journey',
        'description':
        'Enjoy breakfast and begin your return journey.',
      },
    ];

    return Column(
      children: days.map((day) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF2EB),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  day['day']!,
                  style: const TextStyle(
                    color: detailPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day['title']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: detailPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      day['description']!,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.6,
                        color: detailMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIncluded() {
    final items = [
      'Accommodation during the tour',
      'Transportation as per itinerary',
      'Breakfast during the trip',
      'Tour guide assistance',
    ];

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: detailAccent,
                size: 19,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    color: detailMuted,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBookingBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE8ECE9)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: detailPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(tour: tour),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Book this tour',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_rounded, size: 19),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
