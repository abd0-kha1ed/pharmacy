import 'package:flutter/material.dart';
import 'package:phrmacy_system/features/splash/presentation/views/widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: SplashViewBody(),
    );
  }
}
