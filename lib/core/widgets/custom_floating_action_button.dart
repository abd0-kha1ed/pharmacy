import 'package:flutter/material.dart';
import 'package:phrmacy_system/constant.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: kPrimaryColor,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
