import 'package:flutter/material.dart';

class PartnerCard extends StatelessWidget {
const PartnerCard({ super.key });
@override
Widget build(BuildContext context) {
return const Card(
      child: ListTile(
        title: Text('الشريك: '),
        subtitle: Text('نسبة الشراكة: %\nحصة الربح:   جنيه'),
      ),
    );
}
}