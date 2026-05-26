import 'package:cloud_firestore/cloud_firestore.dart';

class GroundBookingModel {
  final String id;
  final String groundName;
  final String place;
  final String playerName;
  final String phone;
  final String sport;
  final String slotTime;
  final int slotIndex;
  final int hours;
  final double amount;
  final DateTime? date;

  GroundBookingModel({
    required this.id,
    required this.groundName,
    required this.place,
    required this.playerName,
    required this.phone,
    required this.sport,
    required this.slotTime,
    required this.slotIndex,
    required this.hours,
    required this.amount,
    required this.date,
  });

  factory GroundBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GroundBookingModel(
      id: doc.id,
      groundName: data['groundName'] ?? '',
      place: data['place'] ?? '',
      playerName: data['playerName'] ?? '',
      phone: data['phone'] ?? '',
      sport: data['sport'] ?? '',
      slotTime: data['slotTime'] ?? '',
      slotIndex: data['slotIndex'] ?? 0,
      hours: data['hours'] ?? 0,
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : null,
    );
  }
}