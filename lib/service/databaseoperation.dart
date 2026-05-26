import 'package:booktoplay_app/models/bookingmodel.dart';
import 'package:booktoplay_app/models/customerground_details.dart';
import 'package:booktoplay_app/models/groundbooking_model.dart';
import 'package:booktoplay_app/models/slot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseOperation {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<GroundBookingModel>> getGroundBookingsStream() {
    return _firestore
        .collection('groundBookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GroundBookingModel.fromFirestore(doc))
              .toList();
        });
  }

  //============================get slot by date=========================

  Stream<List<String>> getBookedSlotsByDate(DateTime selectedDate) {
    final startDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final endDate = startDate.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('bookings')
        .where(
          'bookingDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('bookingDate', isLessThan: Timestamp.fromDate(endDate))
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data();
                return data['slotTime']?.toString().trim() ?? '';
              })
              .where((slot) => slot.isNotEmpty)
              .toList();
        });
  }

  //=====================Customer ground Details==================
  Future<void> saveBookingSummary(
    CustomergroundDetails booking,
    String userId, // Add this parameter
  ) async {
    await FirebaseFirestore.instance.collection('custgrounddetails').add({
      ...booking.toMap(),
      'userId': userId, // Add the Auth UID
    });
  }

  //=============List upcomming Bookings=======================

  Stream<List<CustomergroundDetails>> getUpcomingBookingsByUser(String userId) {
    final now = DateTime.now();

    return FirebaseFirestore.instance
        .collection('custgrounddetails')
        .where('userId', isEqualTo: userId)
        .where('bookingDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('bookingDate')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CustomergroundDetails.fromFirestore(doc))
              .toList();
        });
  }

  //gett all the bookings

  Stream<List<BookingModel>> getUserBookings(String userId) {
    return FirebaseFirestore.instance
        .collection('custgrounddetails')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList();
        });
  }

  //dispaly discount slot
  // Stream<List<SlotDiscountModel>> getSlotDiscounts() {
  //   return FirebaseFirestore.instance
  //       .collection('freeslots')
  //       .snapshots()
  //       .map((snapshot) {
  //     final today = DateTime.now();
  //     final startOfToday = DateTime(today.year, today.month, today.day);
  //     final endOfToday = DateTime(today.year, today.month, today.day, 23, 59, 59);

  //     return snapshot.docs
  //         .map((doc) => SlotDiscountModel.fromFirestore(doc))
  //         .where((slot) {
  //           // Use createdAt instead of date
  //           if (slot.createdAt == null) return false;

  //           final slotDateTime = slot.createdAt!;
  //           return slotDateTime.isAfter(startOfToday) && slotDateTime.isBefore(endOfToday);
  //         })
  //         .toList();
  //   });
  // }
  Stream<List<SlotDiscountModel>> getSlotDiscounts(DateTime selectedDate) {
    final startDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final endDate = startDate.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('freeslots')
        .where(
          'selectedDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('selectedDate', isLessThan: Timestamp.fromDate(endDate))
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SlotDiscountModel.fromFirestore(doc))
              .where((slot) => slot.discountValue > 0)
              .toList();
        });
  }
  //Get All Bookings

  Stream<List<BookingModel>> getAllBookings() {
    return FirebaseFirestore.instance
        .collection('custgrounddetails')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList();
        });
  }
}
