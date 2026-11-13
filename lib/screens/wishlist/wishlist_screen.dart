
import 'package:flutter/material.dart';
import '../../services/wishlist_service.dart';
import '../tours/tour_details_screen.dart';

const Color wishlistPrimary = Color(0xFF102C35);
const Color wishlistAccent = Color(0xFF18A999);
const Color wishlistBackground = Color(0xFFF7F7F2);
const Color wishlistMuted = Color(0xFF778387);

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wishlistBackground,
      appBar: AppBar(
        backgroundColor: wishlistBackground,
        elevation: 0,
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            color: wishlistPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: AnimatedBuilder(
        animation: WishlistService.instance,
        builder: (context, child) {
          final tours = WishlistService.instance.items;

          if (tours.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDDF2EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 42,
                        color: wishlistAccent,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Your wishlist is empty',
                      style: TextStyle(
                        color: wishlistPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Save the tours you love and find them here later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: wishlistMuted,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: tours.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final tour = tours[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          tour['image'] ?? '',
                          height: 175,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              height: 175,
                              color: const Color(0xFFDDECE5),
                              child: const Center(
                                child: Icon(
                                  Icons.landscape_rounded,
                                  size: 45,
                                  color: wishlistAccent,
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: IconButton(
                              onPressed: () {
                                WishlistService.instance.removeTour(tour);
                              },
                              icon: const Icon(
                                Icons.favorite_rounded,
                                color: wishlistAccent,
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
                            tour['name'] ?? '',
                            style: const TextStyle(
                              color: wishlistPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: wishlistAccent,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  tour['location'] ?? '',
                                  style: const TextStyle(
                                    color: wishlistMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tour['price'] ?? '',
                                  style: const TextStyle(
                                    color: wishlistPrimary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TourDetailsScreen(tour: tour),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'View Details',
                                  style: TextStyle(
                                    color: wishlistAccent,
                                    fontWeight: FontWeight.w700,
                                  ),
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
            },
          );
        },
      ),
    );
  }
}
