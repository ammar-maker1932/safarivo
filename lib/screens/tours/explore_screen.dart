
import 'package:flutter/material.dart';
import 'tour_details_screen.dart';

const Color explorePrimary = Color(0xFF102C35);
const Color exploreAccent = Color(0xFF18A999);
const Color exploreBackground = Color(0xFFF7F7F2);
const Color exploreMuted = Color(0xFF778387);

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final searchController = TextEditingController();

  String selectedCategory = 'All';

  final categories = [
    'All',
    'Mountains',
    'Lakes',
    'Adventure',
    'Nature',
  ];

  final tours = [
    {
      'name': 'Hunza Valley Escape',
      'location': 'Hunza, Gilgit-Baltistan',
      'duration': '5 Days / 4 Nights',
      'price': 'Rs. 28,500',
      'category': 'Mountains',
      'image':
      'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
    },
    {
      'name': 'Skardu Adventure',
      'location': 'Skardu, Gilgit-Baltistan',
      'duration': '4 Days / 3 Nights',
      'price': 'Rs. 32,000',
      'category': 'Adventure',
      'image':
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b',
    },
    {
      'name': 'Naran Lake Retreat',
      'location': 'Naran, KPK',
      'duration': '3 Days / 2 Nights',
      'price': 'Rs. 18,500',
      'category': 'Lakes',
      'image':
      'https://images.unsplash.com/photo-1470770841072-f978cf4d019e',
    },
    {
      'name': 'Fairy Meadows',
      'location': 'Diamer, Gilgit-Baltistan',
      'duration': '4 Days / 3 Nights',
      'price': 'Rs. 25,000',
      'category': 'Nature',
      'image':
      'https://images.unsplash.com/photo-1519681393784-d120267933ba',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          final filteredTours = tours.where((tour) {
            final matchesCategory =
                selectedCategory == 'All' ||
                    tour['category'] == selectedCategory;

            final query = searchController.text.toLowerCase();

            final matchesSearch =
                tour['name']!.toLowerCase().contains(query) ||
                    tour['location']!.toLowerCase().contains(query);

            return matchesCategory && matchesSearch;
          }).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 36 : 22,
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
                    const Text(
                      'Explore places\nworth discovering.',
                      style: TextStyle(
                        fontSize: 32,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.2,
                        color: explorePrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Find your perfect escape across Pakistan.',
                      style: TextStyle(
                        fontSize: 14,
                        color: exploreMuted,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildSearch(),
                    const SizedBox(height: 28),
                    const Text(
                      'Explore by interest',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: explorePrimary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildCategories(),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Curated experiences',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: explorePrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${filteredTours.length} tours',
                          style: const TextStyle(
                            color: exploreMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    if (filteredTours.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(35),
                        child: Center(
                          child: Text(
                            'No tours found. Try another search.',
                            style: TextStyle(color: exploreMuted),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredTours.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide ? 3 : 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 280,
                        ),
                        itemBuilder: (context, index) {
                          return _buildTourCard(
                            filteredTours[index],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'safarivo.',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            color: explorePrimary,
          ),
        ),
        const Spacer(),
        const Text(
          'DESTINATIONS',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
            color: exploreMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Search destinations or tours',
        hintStyle: const TextStyle(
          fontSize: 13,
          color: exploreMuted,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: exploreAccent,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFE8ECE9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: exploreAccent),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 9),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              selectedColor: explorePrimary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : exploreMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
                side: BorderSide(
                  color: isSelected
                      ? explorePrimary
                      : const Color(0xFFE8ECE9),
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTourCard(Map<String, String> tour) {
    return GestureDetector(

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TourDetailsScreen(
              tour: tour,
            ),
          ),
        );
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: SizedBox.expand(
                    child: Image.network(
                      tour['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFDDECE5),
                          child: const Icon(
                            Icons.landscape_rounded,
                            size: 40,
                            color: exploreAccent,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 9,
                  left: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tour['category']!,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: explorePrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tour['name']!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: explorePrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tour['location']!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: exploreMuted,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 12,
                color: exploreAccent,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  tour['duration']!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: exploreMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            tour['price']!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: explorePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
