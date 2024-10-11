import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phrmacy_system/constant.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/partner_model.dart';
import 'package:phrmacy_system/features/home/presentation/manger/service/firebase_service.dart';

class PartnerCardListView extends StatelessWidget {
  final String pharmacyId;
  final double netProfit;

  const PartnerCardListView({
    super.key,
    required this.pharmacyId,
    required this.netProfit,
  });

  @override
  Widget build(BuildContext context) {
    final FirebaseServices db = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: db.getPartners(pharmacyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          final List partners = snapshot.data!.docs.map((doc) {
            return PartnerModel.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();

          return Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: partners.length,
              itemBuilder: (context, index) {
                final partner = partners[index];
                final partnerShare =
                    (partner.sharePercentage / 100) * netProfit;

                return Card(
                  color: kCardColor,
                  child: ListTile(
                    title: Text(
                      'الاسم: ${partner.partnerName}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      'نسبة الملكية: ${partner.sharePercentage}%\nحصة الربح: ${partnerShare.toStringAsFixed(2)} جنيه',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('لا توجد بيانات'));
        }
      },
    );
  }
}
