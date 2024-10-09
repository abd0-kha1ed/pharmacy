import 'package:flutter/material.dart';
import 'package:phrmacy_system/constant.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/pharmacy_model.dart';
import 'package:phrmacy_system/features/home/presentation/view/pharmacy_details_view.dart';

class PharmacyCard extends StatelessWidget {
  const PharmacyCard({super.key, required this.pharmacy});
  final PharmacyModel pharmacy;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PharmacyDetailsView(
                pharmacyModel: pharmacy,
              );
            },
          ),
        );
      },
      child: Card(
        color: kCardColor,
        child: ListTile(
          title: Text(pharmacy.pharmacyName),
          leading: const Icon(Icons.local_pharmacy),
        ),
      ),
    );
  }
}
