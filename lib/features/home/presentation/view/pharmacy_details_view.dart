import 'package:flutter/material.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/pharmacy_model.dart';
import 'package:phrmacy_system/features/home/presentation/view/widgets/pharmacy_details_view_body.dart';

class PharmacyDetailsView extends StatelessWidget {
  const PharmacyDetailsView({super.key, required this.pharmacyModel});
  final PharmacyModel pharmacyModel;
  @override
  Widget build(BuildContext context) {
    return  PharmacyDetailsViewBody(pharmacyModel: pharmacyModel,);
  }
}
