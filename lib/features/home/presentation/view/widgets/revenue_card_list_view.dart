import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phrmacy_system/constant.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/pharmacy_model.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/revenue_model.dart';
import 'package:phrmacy_system/features/home/presentation/manger/service/firebase_service.dart';

class RevenueCardListView extends StatefulWidget {
  const RevenueCardListView(
      {super.key,
      required this.selectedMonth,
      required this.selectedYear,
      required this.pharmacyModel});
  final PharmacyModel pharmacyModel;
  final int selectedMonth;
  final int selectedYear;

  @override
  State<RevenueCardListView> createState() => _RevenueCardListViewState();
}

class _RevenueCardListViewState extends State<RevenueCardListView> {
  final FirebaseServices db = FirebaseServices();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> formKey = GlobalKey();

  Future<void> showRevenueDialog({RevenueModel? revenue}) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    if (revenue != null) {
      amountController.text = revenue.amount.toString();
      noteController.text = revenue.note ?? '';
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(revenue == null ? 'أضف مبلغ جديد' : 'تعديل المبلغ'),
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
                    return null;
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
              child: Text(
                revenue == null ? 'إضافة' : 'تعديل',
                style: const TextStyle(color: kTextColor2),
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

                if (revenue == null) {
                  await db.addRevenue(
                      widget.pharmacyModel.pharmacyId, amount!, note);
                } else {
                  await db.updateRevenue(widget.pharmacyModel.pharmacyId,
                      revenue.id, amount!, note);
                }

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
    return StreamBuilder(
      stream: db.getRevenuesByMonthAndYear(widget.pharmacyModel.pharmacyId,
          widget.selectedMonth, widget.selectedYear),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          final List<RevenueModel> revenues = [];

          for (var doc in snapshot.data!.docs) {
            if (doc.exists && doc.data() != null) {
              revenues.add(
                RevenueModel.fromJson(
                    doc.data() as Map<String, dynamic>, doc.id),
              );
            }
          }

          double totalRevenue =
              revenues.fold(0, (sum, revenue) => sum + revenue.amount);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: revenues.length,
                  itemBuilder: (context, index) {
                    final revenue = revenues[index];

                    bool canEditOrDelete = false;
                    if (revenue.createdAt != null) {
                      DateTime now = DateTime.now();
                      DateTime createdAt = revenue.createdAt!;
                      if (now.year == createdAt.year &&
                          now.month == createdAt.month &&
                          now.day == createdAt.day) {
                        canEditOrDelete = true;
                      }
                    }

                    String formattedDate = 'التاريخ غير متاح';
                    if (revenue.createdAt != null) {
                      DateTime dateTime = revenue.createdAt!;
                      formattedDate =
                          DateFormat('EEEE, d MMMM, yyyy').format(dateTime);
                    }

                    return Card(
                      color: kCardColor,
                      child: ListTile(
                        title: Text(
                          'المبلغ: ${revenue.amount} جنيه',
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          'ملاحظة: ${revenue.note}\nالتاريخ: $formattedDate',
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: canEditOrDelete
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            kPrimaryColor)),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showRevenueDialog(revenue: revenue);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  IconButton(
                                    style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            kAccentColor)),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      db.deleteRevenue(
                                          widget.pharmacyModel.pharmacyId,
                                          revenue.id);
                                    },
                                  ),
                                ],
                              )
                            : null, // Hide buttons if cannot edit or delete
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                child: Row(
                  children: [
                    const Text(
                      'المبلغ الإجمالي:   ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '$totalRevenue  جنيه',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
        } else {
          return const Center(child: Text('لا توجد ايرادات'));
        }
      },
    );
  }
}
