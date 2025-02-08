import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phrmacy_system/constant.dart';
import 'package:phrmacy_system/features/home/presentation/manger/models/exports_model.dart';
import 'package:phrmacy_system/features/home/presentation/manger/service/firebase_service.dart';

class ExportsCardListView extends StatefulWidget {
  const ExportsCardListView(
      {super.key,
      required this.pharmacyId,
      required this.selectedMonth,
      required this.selectedYear});
  final String pharmacyId;
  final int selectedMonth;
  final int selectedYear;

  @override
  State<ExportsCardListView> createState() => _ExportsCardListViewState();
}

class _ExportsCardListViewState extends State<ExportsCardListView> {
  final FirebaseServices db = FirebaseServices();
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  Future<void> showExportDialog({ExportsModel? export}) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    if (export != null) {
      amountController.text = export.amount.toString();
      noteController.text = export.note ?? '';
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(export == null ? 'أضف مبلغ جديد' : 'تعديل المبلغ'),
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
              child: Text(
                export == null ? 'إضافة' : 'تعديل',
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

                if (export == null) {
                  await db.addExport(widget.pharmacyId, amount!, note);
                } else {
                  await db.updateExport(
                      widget.pharmacyId, export.id, amount!, note);
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
        stream: db.getExportsByMonthAndYear(
            widget.pharmacyId, widget.selectedMonth, widget.selectedYear),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final List<ExportsModel> exports = [];

            for (var doc in snapshot.data!.docs) {
              if (doc.exists && doc.data() != null) {
                exports.add(
                  ExportsModel.fromJson(
                      doc.data() as Map<String, dynamic>, doc.id),
                );
              }
            }

            double totalExports =
                exports.fold(0, (sum, export) => sum + export.amount);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: exports.length,
                    itemBuilder: (context, index) {
                      final export = exports[index];

                      bool canEditOrDelete(DateTime? createdAt) {
                        if (createdAt == null) return false;
                        DateTime now = DateTime.now();
                        return now.year == createdAt.year &&
                            now.month == createdAt.month &&
                            now.day == createdAt.day;
                      }

                      String formattedDate = 'التاريخ غير متاح';
                      if (export.createdAt != null) {
                        DateTime dateTime = export.createdAt!;
                        formattedDate =
                            DateFormat('EEEE, d MMMM, yyyy').format(dateTime);
                      }

                      return Card(
                        color: kCardColor,
                        child: ListTile(
                          title: Text(
                            'المبلغ: ${export.amount} جنيه',
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            'ملاحظة: ${export.note}\nالتاريخ: $formattedDate',
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: canEditOrDelete(export.createdAt)
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            kPrimaryColor),
                                      ),
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        showExportDialog(export: export);
                                      },
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    IconButton(
                                      style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            kAccentColor),
                                      ),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        await db.deleteExport(
                                            widget.pharmacyId, export.id);
                                      },
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const Text(
                      'المبلغ الإجمالي:   ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '$totalExports  جنيه',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            );
          } else {
            return const Center(child: Text('لا توجد صادرات'));
          }
        });
  }
}
