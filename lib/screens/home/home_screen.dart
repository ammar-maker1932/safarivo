
import 'package:flutter/material.dart';
import '../tours/explore_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../profile/profile_screen.dart';
import '../bookings/my_bookings_screen.dart';
import '../budget/smart_tour_finder_screen.dart';

const Color homePrimary = Color(0xFF102C35);
const Color homeAccent = Color(0xFF18A999);
const Color homeBackground = Color(0xFFF7F7F2);
const Color homeMuted = Color(0xFF778387);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final destinations = [
    {
      'name': 'Hunza Valley',
      'country': 'Gilgit-Baltistan',
      'image':
      'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
    },
    {
      'name': 'Skardu',
      'country': 'Gilgit-Baltistan',
      'image':
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b',
    },
    {
      'name': 'Naran',
      'country': 'Khyber Pakhtunkhwa',
      'image':
      'https://images.unsplash.com/photo-1470770841072-f978cf4d019e',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeBackground,
      body: selectedIndex == 0
          ? SafeArea(child: _buildHomeContent())
          : selectedIndex == 1
          ? const ExploreScreen()
          : selectedIndex == 2
          ? const MyBookingsScreen()
          : const ProfileScreen(),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
        backgroundColor: homeAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SmartTourFinderScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.auto_awesome_rounded,
          size: 25,
        ),
      )
          : null,

      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDDF2EB),
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 40 : 22,
            vertical: 22,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildHeading(),
                  const SizedBox(height: 22),
                  _buildSearch(),
                  const SizedBox(height: 32),
                  _buildSectionTitle(
                    'Featured destination',
                    'Discover more',
                  ),
                  const SizedBox(height: 16),
                  _buildFeaturedCard(),
                  const SizedBox(height: 34),
                  _buildSectionTitle(
                    'Popular destinations',
                    'View all',
                  ),
                  const SizedBox(height: 16),
                  _buildDestinationList(isWide),
                  const SizedBox(height: 34),
                  _buildSectionTitle(
                    'Plan your next escape',
                    'Explore tours',
                  ),
                  const SizedBox(height: 14),
                  _buildTourBanner(),
                  const SizedBox(height: 24),

                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildHeader() {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'safarivo.',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: homePrimary,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'YOUR NEXT ADVENTURE',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 2,
                color: homeMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const Spacer(),

        // Wishlist Button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WishlistScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: homePrimary,
            ),
            tooltip: 'My Wishlist',
          ),
        ),

        const SizedBox(width: 10),

        // Notifications Button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon.'),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: homePrimary,
            ),
          ),
        ),

      ],
    );
  }


  Widget _buildHeading() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find your next',
          style: TextStyle(
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.w500,
            color: homePrimary,
            letterSpacing: -1,
          ),
        ),
        Text(
          'great escape.',
          style: TextStyle(
            fontSize: 34,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: homePrimary,
            letterSpacing: -1.4,
          ),
        ),
        SizedBox(height: 9),
        Text(
          'Explore extraordinary places across Pakistan.',
          style: TextStyle(
            fontSize: 14,
            color: homeMuted,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Where would you like to go?',
        hintStyle: const TextStyle(
          fontSize: 13,
          color: homeMuted,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: homeAccent,
        ),
        suffixIcon: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: homePrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: Colors.white,
            size: 19,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: homePrimary,
              letterSpacing: -0.4,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$action coming soon.')),
            );
          },
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: homeAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF456D70),
                  child: const Icon(
                    Icons.landscape,
                    size: 70,
                    color: Colors.white,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: homeAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Discover the beauty\nof Northern Pakistan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Mountains, lakes and unforgettable journeys',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationList(bool isWide) {
    return SizedBox(
      height: 205,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: destinations.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 14);
        },
        itemBuilder: (context, index) {
          final destination = destinations[index];

          return SizedBox(
            width: isWide ? 245 : 175,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    destination['image']!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        color: const Color(0xFFDDECE5),
                        child: const Icon(
                          Icons.landscape,
                          color: homeAccent,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  destination['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: homePrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  destination['country']!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: homeMuted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTourBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: homePrimary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Made for explorers',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Find curated trips that match your travel style.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.travel_explore_rounded,
            size: 48,
            color: Color(0xFF8ED9C7),
          ),
        ],
      ),
    );
  }


  Widget _buildAIBudgetBanner() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SmartTourFinderScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5ECE9),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF2EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: homeAccent,
                  size: 27,
                ),
              ),

              const SizedBox(width: 15),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Trip Budget Estimator',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: homePrimary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Estimate your travel expenses '
                          'before booking your trip.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: homeMuted,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: homeAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPlaceholder() {
    final titles = [
      '',
      'Explore destinations',
      'My bookings',
      'Your profile',
    ];

    return Center(
      child: Text(
        titles[selectedIndex],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: homePrimary,
        ),
      ),
    );
  }
}
