import 'package:flutter/material.dart';
import 'package:phrmacy_system/constant.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/pharmacy_model.dart';
import 'package:phrmacy_system/features/home/presentation/view/widgets/exports_tab_bar.dart';
import 'package:phrmacy_system/features/home/presentation/view/widgets/partner_tab_bar.dart';
import 'package:phrmacy_system/features/home/presentation/view/widgets/revenue_tab_bar.dart';
import 'package:phrmacy_system/features/home/presentation/view/widgets/yearly_profits_tab_bar.dart';

class PharmacyDetailsViewBody extends StatelessWidget {
  const PharmacyDetailsViewBody({super.key, required this.pharmacyModel});
  final PharmacyModel pharmacyModel;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          
          title: Text(
            pharmacyModel.pharmacyName,
            style: const TextStyle(color: kTextColor1),
          ),
          backgroundColor: kPrimaryColor,
          bottom: TabBar(tabs: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              child: const Tab(
                child: Text(
                  'الإيرادات',
                  style: TextStyle(color: kTextColor1),
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: const Tab(
                  child: Text(
                    'الصادرات',
                    style: TextStyle(color: kTextColor1),
                  ),
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: const Tab(
                  child: Text(
                    'الشركاء',
                    style: TextStyle(color: kTextColor1),
                  ),
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: const Tab(
                  child: Text(
                    'الارباح السنوية',
                    style: TextStyle(color: kTextColor1),
                  ),
                )),
          ]),
        ),
        body: TabBarView(children: [
          RevenueTabBar(
            pharmacyModel: pharmacyModel,
          ),
          ExportsTabBar(
            pharmacyModel: pharmacyModel,
          ),
          PartnerTabBar(
            pharmacyModel: pharmacyModel,
          ),
          YearlyProfitsTabBar(
            pharmacyModel: pharmacyModel,
          ),
        ]),
      ),
    );
  }
}
