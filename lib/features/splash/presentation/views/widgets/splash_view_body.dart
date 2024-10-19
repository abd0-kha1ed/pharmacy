import 'package:flutter/material.dart';
import 'package:phrmacy_system/core/utils/assets_data.dart';
import 'package:phrmacy_system/features/home/presentation/view/home_view.dart';
import 'package:phrmacy_system/features/splash/presentation/views/widgets/sliding_text.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();
    initSlidingAnimation();
    navigateToHomeView();
  }

  @override
  void setState(VoidCallback fn) {
void dispose() {
    super.dispose();
    animationController.dispose();
  }    super.setState(fn);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light Blue Background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            AssetsData.logo,
            height: 200,
            width: 250, 
          ),
          const SizedBox(height: 20),
          SlidingText(slidingAnimation: slidingAnimation),
          const SizedBox(height: 40),
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFE91E63), 
            ),
          ),
        ],
      ),
    );
  }

  void navigateToHomeView() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const HomeView();
          },
        ),
      );
    });
  }

  void initSlidingAnimation() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 15), end: Offset.zero)
            .animate(animationController);

    animationController.forward();
  }
}
