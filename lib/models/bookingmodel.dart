import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingModel {
  final String id;
  final String userId;
  final String customerName;
  final String phoneNumber;
  final String groundName;
  final String place;
  final String sport;
  final String slotTime;
  final double amount;
  final DateTime? bookingDate;
  final DateTime? createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.phoneNumber,
    required this.groundName,
    required this.place,
    required this.sport,
    required this.slotTime,
    required this.amount,
    this.bookingDate,
    this.createdAt,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final user = FirebaseAuth.instance.currentUser;

    return BookingModel(
      id: doc.id,
      userId: user!.uid,
      customerName: data['customerName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      groundName: data['groundName'] ?? '',
      place: data['place'] ?? '',
      sport: data['sport'] ?? '',
      slotTime: data['slotTime'] ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      bookingDate: data['bookingDate'] != null
          ? (data['bookingDate'] as Timestamp).toDate()
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'groundName': groundName,
      'place': place,
      'sport': sport,
      'slotTime': slotTime,
      'amount': amount,
      'bookingDate': bookingDate != null
          ? Timestamp.fromDate(bookingDate!)
          : null,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}