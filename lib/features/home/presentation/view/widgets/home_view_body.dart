import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phrmacy_system/constant.dart';
import 'package:phrmacy_system/features/home/presentation/manger/service/firebase_service.dart';
import 'package:phrmacy_system/features/home/presentation/view/widgets/pharmacy_card_list_view.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final FirebaseServices db = FirebaseServices();
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    void showAddPharmacyDialog() {
      final nameController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: formKey,
            autovalidateMode: _autovalidateMode,
            child: AlertDialog(
              title: const Text('إضافة صيدلية جديدة'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'برجاء إدخال الاسم';
                      }
                      return null;
                    },
                    controller: nameController,
                    autofocus: true,
                    decoration:
                        const InputDecoration(labelText: 'اسم الصيدلية'),
                  ),
                ],
              ),
              actions: <Widget>[
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
                      setState(() {
                        _autovalidateMode = AutovalidateMode.always;
                      });
                    }

                    final name = nameController.text;

                    if (name.isNotEmpty) {
                      try {
                        await db.addPharmacy(name);
                        Navigator.of(context).pop();
                      } on FirebaseException catch (e) {
                        print('Error adding pharmacy: ${e.message}');
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'الصيدليات',
          style: TextStyle(color: kTextColor1),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: PharmacyCardListView(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          showAddPharmacyDialog();
        },
        child: const Icon(
          Icons.add,
          color: kTextColor1,
        ),
      ),
    );
  }
}
