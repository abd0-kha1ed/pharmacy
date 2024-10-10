import 'package:cloud_firestore/cloud_firestore.dart';

class RevenueModel {
  final String id;
  final double amount;
  final String? note;
  final DateTime? createdAt;

  RevenueModel({
    required this.id,
    required this.amount,
    required this.note,
    this.createdAt,
  });

  factory RevenueModel.fromJson(Map<String, dynamic> jsonData, String id) {
    return RevenueModel(
      id: id,
      amount: (jsonData['amount'] as num).toDouble(),
      note: jsonData['notes'] ?? '',
      createdAt: (jsonData['createdAt'] != null)
          ? (jsonData['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}
