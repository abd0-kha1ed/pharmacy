import 'package:flutter/material.dart';
import 'package:phrmacy_system/constant.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/partner_model.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/pharmacy_model.dart';
import 'package:phrmacy_system/features/home/presentation/manger/service/firebase_service.dart';

class YearlyProfitsTabBar extends StatefulWidget {
  const YearlyProfitsTabBar({super.key, required this.pharmacyModel});
  final PharmacyModel pharmacyModel;

  @override
  State<YearlyProfitsTabBar> createState() => _YearlyProfitsTabBarState();
}

class _YearlyProfitsTabBarState extends State<YearlyProfitsTabBar> {
  final FirebaseServices db = FirebaseServices();

  int selectedYear = DateTime.now().year;

  double totalRevenue = 0;
  double totalExpenses = 0;
  double totalProfit = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            DropdownButton<int>(
              iconEnabledColor: kPrimaryColor,
              value: selectedYear,
              items: List.generate(10, (index) {
                int year = DateTime.now().year - index;
                return DropdownMenuItem(value: year, child: Text('$year'));
              }),
              onChanged: (value) {
                setState(() {
                  selectedYear = value!;
                });
                calculateYearlyProfit();
              },
            ),
            StreamBuilder(
              stream: db.getRevenuesByYear(
                  widget.pharmacyModel.pharmacyId, selectedYear),
              builder: (context, revenueSnapshot) {
                if (revenueSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (revenueSnapshot.hasData) {
                  totalRevenue = 0;
                  for (var doc in revenueSnapshot.data!.docs) {
                    totalRevenue += (doc['amount'] ?? 0.0) as double;
                  }
                }
                return StreamBuilder(
                  stream: db.getExpensesByYear(
                    widget.pharmacyModel.pharmacyId,
                    selectedYear,
                  ),
                  builder: (context, expenseSnapshot) {
                    if (expenseSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (expenseSnapshot.hasData) {
                      totalExpenses = 0;
                      for (var doc in expenseSnapshot.data!.docs) {
                        totalExpenses += (doc['amount'] ?? 0.0) as double;
                      }

                      totalProfit = totalRevenue - totalExpenses;
                    }

                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Text('إجمالي الإيرادات: $totalRevenue جنيه'),
                        Text('إجمالي المصروفات: $totalExpenses جنيه'),
                        Text('الربح السنوي: $totalProfit جنيه'),
                        const Divider(),
                        displayPartnerProfits(),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget displayPartnerProfits() {
    return StreamBuilder(
      stream: db.getPartners(widget.pharmacyModel.pharmacyId),
      builder: (context, partnerSnapshot) {
        if (partnerSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (partnerSnapshot.hasData) {
          List<PartnerModel> partners = [];

          for (var doc in partnerSnapshot.data!.docs) {
            partners
                .add(PartnerModel.fromJson(doc.data() as Map<String, dynamic>));
          }

          return Column(
            children: partners.map((partner) {
              double partnerProfit =
                  totalProfit * (partner.sharePercentage / 100);
              return Card(
                color: kCardColor,
                child: ListTile(
                  title: Text('شريك: ${partner.partnerName}'),
                  subtitle: Text('نسبة الشريك: ${partner.sharePercentage}%'),
                  trailing: Text('نصيب الشريك من الأرباح: $partnerProfit جنيه'),
                ),
              );
            }).toList(),
          );
        } else {
          return const Text('لا يوجد شركاء.');
        }
      },
    );
  }

  void calculateYearlyProfit() {
    setState(() {
      totalRevenue = 0;
      totalExpenses = 0;
      totalProfit = 0;
    });
  }
}
