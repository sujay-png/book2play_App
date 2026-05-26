import 'package:booktoplay_app/models/groundbooking_model.dart';
import 'package:booktoplay_app/screen/bookingGround/bookingsummarypage.dart';
import 'package:booktoplay_app/service/databaseoperation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class GroundsResultPage extends StatefulWidget {
  final String sportsname;

  //final String selectedArea;

  const GroundsResultPage({
    super.key,
    required this.sportsname,

    // required this.selectedArea,
  });

  @override
  State<GroundsResultPage> createState() => _GroundsResultPageState();
}

class _GroundsResultPageState extends State<GroundsResultPage> {
  final DatabaseOperation groundBookingService = DatabaseOperation();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    // int durationInt = int.tryParse(widget.selectedHour!.split(' ')[0]) ?? 1;

    // DateTime endTime = now.add(Duration(hours: durationInt));
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String startTimeStr = DateFormat('HH:mm').format(now);
    // String endTimeStr = DateFormat('HH:mm').format(endTime);

    return Scaffold(
      backgroundColor:Colors.black, // Matches your minty background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Book2Play",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            Text(
              widget.sportsname,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),

            // INFO BAR (Summary of selection)
            const SizedBox(height: 25),
            const Text(
              "Available Grounds",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            const SizedBox(height: 10),

            StreamBuilder<List<GroundBookingModel>>(
              stream: groundBookingService.getGroundBookingsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No ground bookings found"));
                }

                final groundBookings = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groundBookings.length,
                  itemBuilder: (context, index) {
                    final booking = groundBookings[index];

                    return _buildGroundCard(context, booking);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroundCard(BuildContext context, GroundBookingModel booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey, width: 2)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.groundName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${booking.amount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Text(
                    "per hour",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 15),
              const SizedBox(width: 4),
              Text(
                booking.place,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, size: 15, color: Colors.orange),
              const Text(
                " 4.5",
                style: TextStyle(color: Colors.orange, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            "${booking.place} Main Road, Mangalore",
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _launchGoogleMaps();
                  },
                  icon: const Icon(Icons.near_me_outlined, size: 18),
                  label: const Text("Get Directions"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingSummaryPage(booking: booking,Sportsname: widget.sportsname,),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //Google Map Function

Future<void> _launchGoogleMaps() async {
  const String address = "1600 Amphitheatre Pkwy, Mountain View, CA";

  final Uri googleMapsUrl = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}",
  );

  final bool launched = await launchUrl(
    googleMapsUrl,
    mode: LaunchMode.externalApplication,
  );

  if (!launched) {
    throw Exception('Could not launch Google Maps');
  }
}

  }
