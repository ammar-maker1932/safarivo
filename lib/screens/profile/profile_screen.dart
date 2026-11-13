
import 'package:flutter/material.dart';
import '../wishlist/wishlist_screen.dart';

const Color profilePrimary = Color(0xFF102C35);
const Color profileAccent = Color(0xFF18A999);
const Color profileBackground = Color(0xFFF7F7F2);
const Color profileMuted = Color(0xFF778387);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Ammar Rauf';
  String userEmail = 'ammar@example.com';
  String userPhone = '+92 300 1234567';

  void _showEditProfile() {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: userEmail);
    final phoneController = TextEditingController(text: userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            24,
            22,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit profile',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: profilePrimary,
                  ),
                ),
                const SizedBox(height: 20),
                _editField('Full name', nameController),
                const SizedBox(height: 14),
                _editField('Email address', emailController),
                const SizedBox(height: 14),
                _editField('Phone number', phoneController),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: profilePrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () {
                      if (nameController.text.trim().isEmpty ||
                          emailController.text.trim().isEmpty) {
                        return;
                      }

                      setState(() {
                        userName = nameController.text.trim();
                        userEmail = emailController.text.trim();
                        userPhone = phoneController.text.trim();
                      });

                      Navigator.pop(sheetContext);
                    },
                    child: const Text(
                      'Save changes',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _editField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: profilePrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: profileBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text(
            'Are you sure you want to log out of your account?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showMessage('Logout will be connected with Firebase later.');
              },
              child: const Text(
                'Log out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    color: profilePrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Manage your account and travel preferences.',
                  style: TextStyle(
                    fontSize: 13,
                    color: profileMuted,
                  ),
                ),
                const SizedBox(height: 25),

                _buildProfileCard(),

                const SizedBox(height: 28),
                _sectionTitle('My travel'),
                const SizedBox(height: 12),

                _buildMenuCard([
                  _menuItem(
                    icon: Icons.luggage_outlined,
                    title: 'My Bookings',
                    subtitle: 'View your upcoming and past trips',
                    onTap: () => _showMessage(
                      'My Bookings screen is coming next.',
                    ),
                  ),
                  _menuItem(
                    icon: Icons.favorite_border_rounded,
                    title: 'My Wishlist',
                    subtitle: 'Your saved destinations and tours',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WishlistScreen(),
                        ),
                      );
                    },
                  ),
                ]),

                const SizedBox(height: 25),
                _sectionTitle('Preferences & support'),
                const SizedBox(height: 12),

                _buildMenuCard([
                  _menuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: 'Manage your travel updates',
                    onTap: () => _showMessage(
                      'Notification settings are coming soon.',
                    ),
                  ),
                  _menuItem(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () => _showMessage(
                      'Language options are coming soon.',
                    ),
                  ),
                  _menuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    subtitle: 'Get help with your trips',
                    onTap: () => _showMessage(
                      'Help Center is coming soon.',
                    ),
                  ),
                  _menuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About Safarivo',
                    subtitle: 'Learn more about our app',
                    onTap: () => _showMessage(
                      'About Safarivo page is coming soon.',
                    ),
                    showDivider: false,
                  ),
                ]),

                const SizedBox(height: 25),

                InkWell(
                  onTap: _showLogoutDialog,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 17,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                          size: 21,
                        ),
                        SizedBox(width: 13),
                        Text(
                          'Log out',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'SAFARIVO  •  YOUR NEXT ADVENTURE',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: profileMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDECE5),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'AR',
                    style: TextStyle(
                      color: profilePrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: profilePrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: profileMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _showEditProfile,
                tooltip: 'Edit profile',
                icon: const Icon(
                  Icons.edit_outlined,
                  color: profileAccent,
                  size: 21,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0xFFF0F1ED), height: 1),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 17,
                color: profileMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  userPhone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: profilePrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: _showEditProfile,
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: profileAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: profilePrimary,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(children: children),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4EF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: profilePrimary,
              size: 21,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: profilePrimary,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: profileMuted,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: profileMuted,
            size: 21,
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 72),
            child: Divider(
              height: 1,
              color: Color(0xFFF0F1ED),
            ),
          ),
      ],
    );
  }
}
