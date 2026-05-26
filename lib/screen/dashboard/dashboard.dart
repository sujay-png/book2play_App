import 'package:booktoplay_app/components/kpiboxes.dart';
import 'package:booktoplay_app/models/bookingmodel.dart';
import 'package:booktoplay_app/models/customerground_details.dart';
import 'package:booktoplay_app/models/slot_model.dart';
import 'package:booktoplay_app/screen/bookingGround/bookingground.dart';
import 'package:booktoplay_app/screen/bookingGround/grounddetails.dart';
import 'package:booktoplay_app/service/databaseoperation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final String useremail =
        FirebaseAuth.instance.currentUser?.email ?? "Guest@user.com";
    String selected = "1 Hour";
    final user = FirebaseAuth.instance.currentUser;
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
              'My Dashboard',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              displayName,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<List<BookingModel>>(
                stream: user == null
                    ? Stream.value([])
                    : DatabaseOperation().getUserBookings(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final bookings = snapshot.data ?? [];                 
                  final upcomingBookings = bookings.where((booking) {
                    return booking.bookingDate != null &&
                        booking.bookingDate!.isAfter(DateTime.now());
                  }).length;

                  final now = DateTime.now();

                  final thisMonthBookings = bookings.where((booking) {
                    return booking.bookingDate != null &&
                        booking.bookingDate!.month == now.month &&
                        booking.bookingDate!.year == now.year;
                  }).length;

                  // Total Spent
                  final totalSpent = bookings.fold<double>(
                    0,
                    (sum, booking) => sum + booking.amount,
                  );

                  return Row(
                    children: [
                      Expanded(
                        child: Kpiboxes(
                          title: upcomingBookings.toString(),
                          textcolor: Colors.greenAccent,
                          subtile: 'Upcoming',
                        ),
                      ),

                      Expanded(
                        child: Kpiboxes(
                          title: thisMonthBookings.toString(),
                          textcolor: Colors.blueAccent,
                          subtile: 'This Month',
                        ),
                      ),

                      Expanded(
                        child: Kpiboxes(
                          icon: Icons.currency_rupee_rounded,
                          iconcolor: Colors.amber,
                          title: totalSpent >= 1000
                              ? "${(totalSpent / 1000).toStringAsFixed(1)}K"
                              : totalSpent.toStringAsFixed(0),
                          textcolor: Colors.amber,
                          subtile: 'Spent',
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Bookingground()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D9A3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.black, size: 20),
                      SizedBox(width: 8),

                      Text(
                        "Book a new ground",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Upcomming Bookings
              SizedBox(height: 15),

              //==================Display discount slots==============================
              Text(
                'Discount Slots',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 12),

              StreamBuilder<List<SlotDiscountModel>>(
                stream: DatabaseOperation().getSlotDiscounts(selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox();
                  }

                  final discounts = snapshot.data!;

                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: discounts.length,
                      itemBuilder: (context, index) {
                        final discount = discounts[index];

                        return Container(
                          width: 260,
                          margin: const EdgeInsets.only(right: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A1212),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF00D9A3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Special Slot Offer",
                                style: TextStyle(
                                  color: Color(0xFF00D9A3),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                discount.slotTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                discount.discountType == 'percentage'
                                    ? "${discount.discountValue.toStringAsFixed(0)}% OFF"
                                    : "₹${discount.discountValue.toStringAsFixed(0)} OFF",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const Spacer(),

                              const Text(
                                "Book now and save more",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),
              const SizedBox(height: 20),
              Text(
                'Upcomming Bookings',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 15),

              StreamBuilder<List<CustomergroundDetails>>(
  stream: DatabaseOperation().getUpcomingBookingsByUser(currentUserId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Text(
          "No Upcoming Bookings",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final bookings = snapshot.data!;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.sports_soccer,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.groundName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          booking.slotTime,
                          style: const TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          booking.bookingDate != null
                              ? "${booking.bookingDate!.day}/${booking.bookingDate!.month}/${booking.bookingDate!.year}"
                              : "",
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "₹${booking.amount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                "Players",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              if (booking.players.isEmpty)
                const Text(
                  "No player details",
                  style: TextStyle(color: Colors.white54),
                )
              else
                Column(
                  children: booking.players.map((player) {
                    final name = player['name'] ?? '';
                    final phone = player['phone'] ?? '';
                    final splitAmount =
                        (player['splitAmount'] as num?)?.toDouble() ?? 0.0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.greenAccent,
                            size: 20,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  phone.toString(),
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            "₹${splitAmount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  },
)
            ],

            //
          ),
        ),
      ),
    );
  }
}
