  import 'package:booktoplay_app/models/groundbooking_model.dart';
import 'package:booktoplay_app/screen/bookings/booking.dart';
import 'package:booktoplay_app/screen/share.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class BookingSuccessPage extends StatelessWidget {
   final String Sportsname;
    final GroundBookingModel booking;
  const BookingSuccessPage({super.key, required this.Sportsname,  required this.booking});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor:Colors.black, // Minty background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.blue.shade100),

            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. SUCCESS CHECKMARK
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF00C853),
                  child: Icon(Icons.check, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 20),
                 Text(
                  "Booking Successful!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                Text(Sportsname, style: const TextStyle(color: Colors.blueGrey)),
                
                const SizedBox(height: 30),

                // 2. BOOKING DETAILS CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9), // Light green
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade100),
                  ),
                  child:  Column(
                    children: [
                      Text( booking.groundName, 
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                         Text(
                              "${booking.place}  ₹${booking.amount.toStringAsFixed(0)}/hour",
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 16,
                              ),
                            ),
                    
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. NEXT STEPS BOX
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD), // Light blue
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    children: [
                      const Text("Next Steps", 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      const Text("✓ Booking confirmed with court owner", 
                        style: TextStyle(fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 8),
                      const Text("🗄️ Go to your dashboard to:", 
                        style: TextStyle(fontSize: 13, color: Colors.black87)),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• Add players to split costs", style: TextStyle(fontSize: 12, color: Colors.black54)),
                            Text("• Track who paid their share", style: TextStyle(fontSize: 12, color: Colors.black54)),
                            Text("• Share booking details with teammates", style: TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 4. ACTION BUTTONS
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>ShareScreen()));
                    },
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: const Text("Share with Teammates"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4), // Google Blue
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5F5),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Book Another Ground"),
                  ),
                ),

                const SizedBox(height: 30),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}