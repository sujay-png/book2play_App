import 'package:booktoplay_app/auth/mobile_login.dart';
import 'package:flutter/material.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D9A3), Color(0xFF7B61FF)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Book2Play',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose how youd like to continue',
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 32),
                //Book a ground container
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>MobileLoging()));
                    },
                    child: Container(
                      width: 400,
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        // Darker, more transparent color to match the image
                        color: const Color(0xFF161B1B).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white70, width: 1),
                      ),
                      child: Column(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.sports_cricket_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                          Text(
                            'Book a ground',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          Text(
                            'Find and book available sports ground ',
                            style: TextStyle(color: Colors.white70, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //Court Owner Container
                SizedBox(height: 15),
                // GestureDetector(
                //   onTap: () {
                //      context.go('/login');

                //   },
                //   child: Container(
                //     width: 400,
                //     constraints: const BoxConstraints(maxWidth: 500),
                //     padding: const EdgeInsets.all(24),
                //     decoration: BoxDecoration(
                //       // Darker, more transparent color to match the image
                //       color: const Color(0xFF161B1B).withOpacity(0.6),
                //       borderRadius: BorderRadius.circular(28),
                //       border: Border.all(color: Colors.white70, width: 1),
                //     ),
                //     child: Column(
                //       spacing: 5,
                //       children: [
                //         Icon(Icons.settings, size: 40, color: Colors.white),
                //         Text(
                //           'Court Owner',
                //           style: TextStyle(color: Colors.white, fontSize: 25),
                //         ),
                //         Text(
                //           'Manage Your Sports Ground ',
                //           style: TextStyle(color: Colors.white70, fontSize: 15),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
