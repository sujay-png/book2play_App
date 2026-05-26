import 'package:booktoplay_app/auth/mobile_login.dart';
import 'package:booktoplay_app/components/quickstats.dart';
import 'package:booktoplay_app/models/bookingmodel.dart';
import 'package:booktoplay_app/service/databaseoperation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final String useremail =
        FirebaseAuth.instance.currentUser?.email ?? "Guest@user.com";
    String displayName = useremail.split('@')[0];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.black,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Profile',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //==========Profile=======================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF0A1212,
                      ), // Deep black-green surface
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // 1. The Main Avatar
                            CircleAvatar(
                              radius: 35, // Size of the avatar
                              backgroundColor: const Color(
                                0xFF00D9A3,
                              ), // Your mint color
                              child: const Text(
                                'AJ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // 2. The Verified Badge
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(
                                  2,
                                ), // Padding for the black border effect
                                decoration: const BoxDecoration(
                                  color: Colors.black, // The thick black ring
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Color(
                                    0xFF81C784,
                                  ), // Lighter green for the check mark
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          displayName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700, // Bold but not heavy
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          useremail,
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  // ===========PERFORMANCE =======================
                  Text(
                    'PERFORMANCE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 15),
                  StreamBuilder<List<BookingModel>>(
                    stream: DatabaseOperation().getUserBookings(user!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final bookings = snapshot.data ?? [];

                      // Dynamic values
                      final totalBookings = bookings.length;

                      final totalSpent = bookings.fold<double>(
                        0,
                        (sum, booking) => sum + booking.amount,
                      );

                      return Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Quickstats(
                              value: totalBookings.toString(),
                              label: 'Bookings',
                            ),
                          ),
                          Expanded(
                            child: Quickstats(
                              value: "₹${totalSpent.toStringAsFixed(0)}",
                              label: 'Total Spent',
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 15),

                  //============Accounts==========================
                  Text(
                    'ACCOUNT',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildSettingTile(
                    title: 'Account Details',
                    subtitle: 's@gmail.com',
                    icon: const Icon(Icons.email),
                    containercolor: const Color(0xFF161B1B),
                    onTap: () {
                      User? currentUser = FirebaseAuth.instance.currentUser;

                      if (currentUser != null) {
                        context.go('/accountdetails');
                      } else {
                        // Handle case where user session might have expired
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No authenticated user found. Please log in again.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 50),

                  Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () => context.go('/login'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Logout Out",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                  Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () async{
                       try {
                        final user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          await user.delete();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MobileLoging(),
                            ),
                            (route) => false,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Account deleted successfully"),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'requires-recent-login') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please login again before deleting account",
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }

                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Delete Acount",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //==============Account Details Design=================
  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required Widget icon,
    required Color containercolor,
    required void Function() onTap,
    bool hasActiveBorder = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        20,
      ), // Keeps ink splashes inside the borders
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: containercolor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasActiveBorder
                ? const Color(0xFF00D9A3)
                : Colors.white.withValues(alpha: 0.05),
            width: hasActiveBorder ? 1.5 : 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: containercolor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: icon,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.white70,
            size: 20,
          ),
        ),
      ),
    );
  }
}
