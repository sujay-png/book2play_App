import 'package:booktoplay_app/components/quickstats.dart';
import 'package:flutter/material.dart';

class Eventdetails extends StatelessWidget {
  const Eventdetails({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Event Details',
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //==========================HEADER==========================
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
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        Transform.rotate(
                          angle: -0.2,
                          child: const Icon(
                            Icons.sports_cricket_rounded,
                            size: 50,
                            color: Color(0xFFFFB7B7),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text(
                          'Championship Cricket Tournament',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700, // Bold but not heavy
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),

                        const Text(
                          'May 20-22, 2026 • ABC Sports Arena',
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                        const SizedBox(height: 20),

                        // Custom Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF161B1B,
                            ), // Dark contrast pill
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF00D9A3).withValues(alpha: 0.15),
                            ),
                          ),
                          child: const Text(
                            'REGISTRATIONS OPEN',
                            style: TextStyle(
                              color: Color(0xFF00D9A3),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  //=====================EVENT INFO===================================
                  Text(
                    'Event Info',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1212),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(spacing: 15, children: [EventCard()]),
                  ),

                  //=============Event Description=================
                  SizedBox(height: 15),
                  Text(
                    'About Event',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1212),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      spacing: 15,
                      children: [
                        Text(
                          'Join the most exciting cricket tournament of the season! Compete with teams from across the city, showcase your skills, and win amazing prizes. Teams of 8-12 players required. Experience professional-level gameplay with expert umpires and top-notch facilities.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //===============Quick Stats======================
                  SizedBox(height: 15,),
                  Text(
                    'Quick Stats',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 15,),

                  Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Quickstats(
                          value: '24', 
                          label: 'Teams Registerd')),
                          Expanded(
                        child: Quickstats(
                          value: '500,000', 
                          label: 'Prize Pool')),
                    ],
                  ),
                  SizedBox(height: 15,),

                    Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Quickstats(
                          value: '48', 
                          label: 'Total Slots')),
                          Expanded(
                        child: Quickstats(
                          value: '18', 
                          label: 'slot left')),
                    ],
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );

    //Event card Design
  }

  Widget EventCard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 15,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1212),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Icon(Icons.calendar_month, size: 20, color: Colors.white),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
                Text(
                  'May 20-22,2026',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 15,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1212),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Icon(Icons.calendar_month, size: 20, color: Colors.white),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time',
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
                Text(
                  '6:00 PM - 10:00 PM Daily',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 15,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1212),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Icon(Icons.calendar_month, size: 20, color: Colors.white),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Venue',
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
                Text(
                  'ABC Sports Arena, Kadri',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
