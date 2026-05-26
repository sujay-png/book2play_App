import 'package:booktoplay_app/models/customerground_details.dart';
import 'package:booktoplay_app/models/groundbooking_model.dart';
import 'package:booktoplay_app/screen/bookingGround/BookingSuccessPage.dart';
import 'package:booktoplay_app/service/databaseoperation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlayerInput {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
  }
}

class BookingSummaryPage extends StatefulWidget {
  final String Sportsname;
  final GroundBookingModel booking;

  const BookingSummaryPage({
    super.key,
    required this.booking,
    required this.Sportsname,
  });

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController timeoutController = TextEditingController();
  final DatabaseOperation groundBookingService = DatabaseOperation();
  TextEditingController playername = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<PlayerInput> players = [PlayerInput()];

  DateTime? selectedDate;
  String? selectedSlotTime;

  final List<String> slots = [
    '06:00 AM - 07:00 AM',
    '07:00 AM - 08:00 AM',
    '08:00 AM - 09:00 AM',
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '01:00 PM - 02:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
    '05:00 PM - 06:00 PM',
    '06:00 PM - 07:00 PM',
    '07:00 PM - 08:00 PM',
    '08:00 PM - 09:00 PM',
    '10:00 PM - 11:00 PM',
    '11:00 PM - 12:00 AM',
  ];
  @override
  void dispose() {
    dateController.dispose();

    for (final player in players) {
      player.dispose();
    }

    super.dispose();
  }

  double get splitAmount {
    if (players.isEmpty) return 0;
    return widget.booking.amount / players.length;
  }

  @override
  Widget build(BuildContext context) {
    final GroundBookingModel booking = widget.booking;

    return Scaffold(
      backgroundColor: Colors.black, // Minty background
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Book Now", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Book Now",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // GROUND INFO BOX
              // GROUND INFO BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.booking.groundName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.booking.place}  ₹${widget.booking.amount.toStringAsFixed(0)}/hour",
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.Sportsname,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              _buildReadOnlyField(),

              const SizedBox(height: 25),

              // PAY BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedDate == null || selectedSlotTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select date and slot"),
                        ),
                      );
                      return;
                    }
                    final validPlayers = players
                        .map(
                          (p) => {
                            'name': p.nameController.text.trim(),
                            'phone': p.phoneController.text.trim(),
                          },
                        )
                        .where(
                          (p) =>
                              p['name']!.isNotEmpty && p['phone']!.isNotEmpty,
                        )
                        .toList();

                    if (validPlayers.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please add at least one player"),
                        ),
                      );
                      return;
                    }

                    final double perPlayerAmount =
                        booking.amount / validPlayers.length;

                    final playersWithSplitAmount = validPlayers.map((p) {
                      return {
                        'name': p['name'],
                        'phone': p['phone'],
                        'splitAmount': perPlayerAmount,
                      };
                    }).toList();
                    try {
                      final bookingModel = CustomergroundDetails(
                        id: '',
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        customerName: playername.text.trim(),
                        phoneNumber: phonenumber.text.trim(),
                        groundName: booking.groundName,
                        place: booking.place,
                        sport: booking.sport,
                        slotTime: selectedSlotTime!,
                        amount: booking.amount,
                        bookingDate: selectedDate!,
                        players: playersWithSplitAmount,
                      );

                      await groundBookingService.saveBookingSummary(
                        bookingModel,
                        FirebaseAuth.instance.currentUser!.uid,
                      );

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingSuccessPage(
                              booking: booking,
                              Sportsname: widget.Sportsname,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Proceed to Pay  Court Owner",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Players',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: players.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Player ${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (players.length > 1)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              players[index].dispose();
                              players.removeAt(index);
                            });
                          },
                        ),
                    ],
                  ),

                  TextField(
                    controller: players[index].nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Enter Player Name",
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: players[index].phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Enter Phone Number",
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Amount: ₹${splitAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                players.add(PlayerInput());
              });
            },
            icon: const Icon(Icons.add, color: Colors.green),
            label: const Text(
              "Add Player",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: Text(
            "Total Amount: ₹${widget.booking.amount.toStringAsFixed(2)}\n"
            "Players: ${players.length}\n"
            "Split Amount: ₹${splitAmount.toStringAsFixed(2)} per player",
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text('Date', style: TextStyle(color: Colors.white, fontSize: 15)),

        TextField(
          style: const TextStyle(color: Colors.white, fontSize: 16),
          controller: dateController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Select Date",
            labelStyle: TextStyle(color: Colors.white70),
            suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              String formattedDate =
                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";

              setState(() {
                selectedDate = pickedDate;
                selectedSlotTime = null;
                dateController.text = formattedDate;
              });
            }
          },
        ),

        const SizedBox(height: 20),

        const Text(
          'Select Time Slot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        if (selectedDate == null)
          const Text(
            "Please select date first",
            style: TextStyle(color: Colors.greenAccent),
          )
        else
          StreamBuilder<List<String>>(
            stream: groundBookingService.getBookedSlotsByDate(selectedDate!),
            builder: (context, snapshot) {
              final bookedSlots = snapshot.data ?? [];

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: slots.map((slot) {
                  final cleanedSlot = slot.trim();
                  final isBooked = bookedSlots.contains(slot.trim());
                  final isSelected = selectedSlotTime == slot;
                  final isPast = _isSlotPast(cleanedSlot, selectedDate!);
                  final isUnavailable = isBooked || isPast;

                  return InkWell(
                    onTap: isUnavailable
                        ? null
                        : () {
                            setState(() {
                              selectedSlotTime = slot;
                            });
                          },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isPast
                            ? Colors
                                  .grey
                                  .shade300 // Grey out past slots
                            : isBooked
                            ? Colors.red.shade50
                            : isSelected
                            ? Colors.green
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isPast
                              ? Colors.grey.shade400
                              : isBooked
                              ? Colors.red
                              : isSelected
                              ? Colors.green
                              : Colors.green.shade300,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(slot, textAlign: TextAlign.center),
                          const SizedBox(height: 5),
                          Text(
                            isPast
                                ? "EXPIRED"
                                : isBooked
                                ? "BOOKED"
                                : "AVAILABLE",
                            style: TextStyle(
                              color: isPast
                                  ? Colors.grey.shade600
                                  : isBooked
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }

  //=====================Helper function===========================
  bool _isSlotPast(String slotTime, DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    if (targetDate.isAfter(today)) {
      return false;
    }
    if (targetDate.isBefore(today)) {
      return true;
    }
    try {
      String startTimeString = slotTime.split('-')[0].trim();

      DateTime parsedTime;
      if (startTimeString.toLowerCase().contains('am') ||
          startTimeString.toLowerCase().contains('pm')) {
        parsedTime = DateFormat("h:mm a").parse(startTimeString);
      } else {
        parsedTime = DateFormat("H:mm").parse(startTimeString);
      }
      final slotDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      return now.isAfter(slotDateTime);
    } catch (e) {
      return false;
    }
  }
}
