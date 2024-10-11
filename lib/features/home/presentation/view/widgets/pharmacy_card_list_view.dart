import 'package:flutter/material.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/pharmacy_model.dart';
import 'package:phrmacy_system/features/home/presentation/manger/service/firebase_service.dart';
import 'package:phrmacy_system/features/home/presentation/view/widgets/pharmacy_card.dart';

class PharmacyCardListView extends StatefulWidget {
  const PharmacyCardListView({super.key});

  @override
  State<PharmacyCardListView> createState() => _PharmacyCardListViewState();
}

class _PharmacyCardListViewState extends State<PharmacyCardListView> {
  final FirebaseServices db = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.getPharmacies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final List<PharmacyModel> pharmacies = [];
            for (var doc in snapshot.data!.docs) {
              if (doc.exists && doc.data() != null) {
                pharmacies.add(
                  PharmacyModel.fromJson({
                    'name': doc['name'],
                    'id': doc.id, 
                  }),
                );
              }
            }

            return ListView.builder(
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                return PharmacyCard(
                  pharmacy: pharmacies[index],
                );
              },
            );
          } else {
            return const Text('Loading');
          }
        });
  }
}
