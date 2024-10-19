import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phrmacy_system/constant.dart';

class CustomDropdownButton extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final Function(int) onMonthChanged;
  final Function(int) onYearChanged;

  const CustomDropdownButton({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<int>(
          value: selectedMonth,
          iconEnabledColor: kPrimaryColor,
          items: List.generate(12, (index) {
            final month = index + 1;
            return DropdownMenuItem(
              value: month,
              child: Text(DateFormat.MMMM().format(DateTime(0, month))),
            );
          }),
          onChanged: (value) {
            if (value != null) {
              onMonthChanged(value);
            }
          },
        ),
        const SizedBox(width: 20),
        DropdownButton<int>(
          value: selectedYear,
          iconEnabledColor: kPrimaryColor,
          items: List.generate(5, (index) {
            final year = DateTime.now().year - index;
            return DropdownMenuItem(
              value: year,
              child: Text(year.toString()),
            );
          }),
          onChanged: (value) {
            if (value != null) {
              onYearChanged(value); // تحديث السنة
            }
          },
        ),
      ],
    );
  }
}
