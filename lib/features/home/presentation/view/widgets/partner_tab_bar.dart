import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phrmacy_system/constant.dart';
import 'package:phrmacy_system/core/widgets/custom_floating_action_button.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/pharmacy_model.dart';
import 'package:phrmacy_system/features/home/presentation/manger/service/firebase_service.dart';
import 'package:phrmacy_system/features/home/presentation/view/widgets/partner_card_list_view.dart';

class PartnerTabBar extends StatefulWidget {
  const PartnerTabBar({super.key, required this.pharmacyModel});
  final PharmacyModel pharmacyModel;

  @override
  State<PartnerTabBar> createState() => _PartnerTabBarState();
}

class _PartnerTabBarState extends State<PartnerTabBar> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final FirebaseServices db = FirebaseServices();
  double netProfit = 0;

  Future<void> calculateNetProfit() async {
    double totalRevenues =
        await db.getTotalRevenues(widget.pharmacyModel.pharmacyId);
    double totalExports =
        await db.getTotalExports(widget.pharmacyModel.pharmacyId);
    setState(() {
      netProfit = totalRevenues - totalExports;
    });
  }

  @override
  void initState() {
    super.initState();
    calculateNetProfit();
  }

  Future<void> addPartner() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final partnerNameController = TextEditingController();
        final sharePercentageController = TextEditingController();

        return AlertDialog(
          title: const Text('أضف شريك جديد'),
          content: Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'برجاء إدخال اسم الشريك';
                    }
                  },
                  controller: partnerNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الشريك',
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'برجاء إدخال نسبة الملكية';
                    }
                  },
                  controller: sharePercentageController,
                  decoration: const InputDecoration(
                    labelText: 'نسبة الملكية',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(kAccentColor),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: kTextColor2),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(kAccentColor),
              ),
              child: const Text(
                'إضافة',
                style: TextStyle(color: kTextColor2),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                } else {
                  autovalidateMode = AutovalidateMode.always;
                  setState(() {});
                  return;
                }

                double? newSharePercentage =
                    double.tryParse(sharePercentageController.text);

                double totalSharePercentage = await db
                    .getTotalSharePercentage(widget.pharmacyModel.pharmacyId);

                if (totalSharePercentage + newSharePercentage! > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('مجموع نسب الشراكة تجاوز 100%!')),
                  );
                  return;
                }

                final partnerName = partnerNameController.text;
                await db.addPartner(widget.pharmacyModel.pharmacyId,
                    partnerName, newSharePercentage);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'الشركاء',
                  style: TextStyle(
                      color: kTextColor2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            PartnerCardListView(
              pharmacyId: widget.pharmacyModel.pharmacyId,
              netProfit: netProfit,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'صافي الربح: ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '$netProfit جنيه',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          addPartner();
        },
      ),
    );
  }
}
