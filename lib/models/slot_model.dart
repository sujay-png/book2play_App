import 'package:cloud_firestore/cloud_firestore.dart';

class SlotDiscountModel {
  final String id;
  final String slotTime;
  final String discountType;
  final double discountValue;
  

  final DateTime? createdAt;

  SlotDiscountModel({
    required this.id,
    required this.slotTime,
    required this.discountType,
    required this.discountValue,
 this.createdAt,
  });

  // FROM FIRESTORE
  factory SlotDiscountModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SlotDiscountModel(
      id: doc.id,
      slotTime: data['slotTime'] ?? '',
      discountType: data['discountType'] ?? '',
      discountValue:
          (data['discountValue'] as num?)?.toDouble() ?? 0.0,
     
      createdAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // TO FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'slotTime': slotTime,
      'discountType': discountType,
      'discountValue': discountValue,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}