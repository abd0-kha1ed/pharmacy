import 'package:cloud_firestore/cloud_firestore.dart';

class ExportsModel {
  final String id;
  final double amount;
  final String? note;
  final DateTime? createdAt;
  

  ExportsModel( {
    required this.id,
    required this.amount,
    required this.note,
    this.createdAt,
  });

  factory ExportsModel.fromJson(Map<String, dynamic> jsonData,String id) {
    return ExportsModel(
      id: id,
      amount: (jsonData['amount'] as num).toDouble(),
      note: jsonData['notes'] ?? '',
      createdAt: (jsonData['createdAt'] != null)
          ? (jsonData['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}
