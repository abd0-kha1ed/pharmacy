import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phrmacy_system/constant.dart';
import 'package:phrmacy_system/core/widgets/custom_dropdown_button.dart';
import 'package:phrmacy_system/core/widgets/custom_floating_action_button.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/pharmacy_model.dart';
import 'package:phrmacy_system/features/home/presentation/manger/service/firebase_service.dart';
import 'package:phrmacy_system/features/home/presentation/view/widgets/revenue_card_list_view.dart';

class RevenueTabBar extends StatefulWidget {
  const RevenueTabBar({
    super.key,
    required this.pharmacyModel,
  });
  final PharmacyModel pharmacyModel;

  @override
  State<RevenueTabBar> createState() => _RevenueTabBarState();
}

class _RevenueTabBarState extends State<RevenueTabBar> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final FirebaseServices db = FirebaseServices();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  void _updateTransactionsStream(int month, int year) {
    setState(() {
      selectedMonth = month;
      selectedYear = year;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addRevenue() {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          final amountController = TextEditingController();
          final noteController = TextEditingController();

          return AlertDialog(
            title: const Text('أضف مبلغ جديد'),
            content: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'برجاء إدخال المبلغ';
                      }
                    },
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: 'المبلغ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: 'ملاحظة'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(kButtonColor)),
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
                    backgroundColor: WidgetStatePropertyAll(kButtonColor)),
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

                  double? amount = double.tryParse(amountController.text);

                  final note = noteController.text;

                  await db.addRevenue(
                      widget.pharmacyModel.pharmacyId, amount!, note);

                  Navigator.of(context).pop(); 
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CustomDropdownButton(
              selectedMonth: selectedMonth,
              selectedYear: selectedYear,
              onMonthChanged: (month) {
                _updateTransactionsStream(month, selectedYear);
              },
              onYearChanged: (year) {
                _updateTransactionsStream(selectedMonth, year);
              },
            ),
            const Row(
              children: [
                Text(
                  'الإيرادات',
                  style: TextStyle(
                      color: kTextColor2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Flexible(
              child: RevenueCardListView(
                selectedMonth: selectedMonth,
                selectedYear: selectedYear,
                pharmacyModel: widget.pharmacyModel,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          addRevenue();
        },
      ),
    );
  }
}
