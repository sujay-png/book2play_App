import 'package:booktoplay_app/models/bookingmodel.dart';
import 'package:booktoplay_app/service/databaseoperation.dart';
import 'package:booktoplay_app/theme/appcolors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final user = FirebaseAuth.instance.currentUser;

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
              'Bookings History',
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
                children: [
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
                        StreamBuilder<List<BookingModel>>(
                          stream: user == null
                              ? Stream.value([])
                              : DatabaseOperation().getUserBookings(user!.uid),

                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                "Error: ${snapshot.error}",
                                style: const TextStyle(color: Colors.red),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final bookings = snapshot.data ?? [];

                            // Dynamic values
                            final totalBookings = bookings.length;

                            final totalSpent = bookings.fold<double>(
                              0,
                              (sum, booking) => sum + booking.amount,
                            );

                            return Column(
                              children: [
                                // ===== Stats Container =====
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A1212),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total Bookings',
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            totalBookings.toString(),
                                            style: const TextStyle(
                                              color: Color(0xFF00D9A3),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 15),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total Spent',
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "₹${totalSpent.toStringAsFixed(0)}",
                                            style: const TextStyle(
                                              color: Color(0xFF00D9A3),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 25),

                                // ===== Booking List =====
                                if (bookings.isEmpty)
                                  const Center(
                                    child: Text(
                                      "No Bookings Found",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  )
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: bookings.length,
                                    itemBuilder: (context, index) {
                                      return buildBookingCard(bookings[index]);
                                    },
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),


              //Booking Card details
            ],
          ),
        ),
      ),
    );
  }

  //Booking  Card
  Widget buildBookingCard(BookingModel booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  booking.groundName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mint.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'COMPLETED',
                  style: TextStyle(
                    color: AppColors.mint,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            booking.slotTime,
            style: const TextStyle(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _iconLabel(
                Icons.calendar_month,
                booking.bookingDate != null
                    ? "${booking.bookingDate!.day}/${booking.bookingDate!.month}/${booking.bookingDate!.year}"
                    : "No Date",
              ),
              _iconLabel(Icons.alarm, booking.slotTime),
              _iconLabel(Icons.sports_soccer, booking.groundName),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white10),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹${booking.amount.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: AppColors.mint,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconLabel(
    IconData icon,
    String label, {
    Color iconColor = Colors.white70,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}

//Choice Chip
class ActionChoiceExample extends StatefulWidget {
  const ActionChoiceExample({super.key});

  @override
  State<ActionChoiceExample> createState() => _ActionChoiceExampleState();
}

class _ActionChoiceExampleState extends State<ActionChoiceExample> {
  int? _value = 0;
  final List<String> _filters = ['All', 'Completed', 'Cancelled'];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 4,
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.only(bottom: 12),
        child: Wrap(
          spacing: 8.0,
          children: List<Widget>.generate(_filters.length, (int index) {
            bool isSelected = _value == index;
            return ChoiceChip(
              label: Text(_filters[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  _value = selected ? index : null;
                });
              },
              // Text Styling
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF00D9A3) : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: const Color(0xFF161B1B),
              selectedColor: const Color(
                0xFF161B1B,
              ), // Keep same dark bg when selected
              // Border and Shape
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF00D9A3) : Colors.white12,
                  width: 1.5,
                ),
              ),
              showCheckmark: false,
              elevation: 0,
              pressElevation: 0,
            );
          }).toList(),
        ),
      ),
    );
  }
}
