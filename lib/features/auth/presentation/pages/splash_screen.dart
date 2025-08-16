import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/features/auth/presentation/pages/login_page.dart';
import 'package:innerspace_booking_app/features/auth/presentation/pages/widgets/dot_loader.dart';
import 'package:innerspace_booking_app/features/branch/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Colors
  final Color primaryColor = const Color(0xFFB7995B);
  final Color gradientOne = const Color(0xFF5B4C2D);
  final Color gradientTwo = const Color(0xFFC1A15F);

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _checkLoginStatus();
  }

  void _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 20.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gradient Text
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [gradientOne, gradientTwo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: const Text(
                "Innerspace",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Required for ShaderMask
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Animated coworking icon
            Transform.translate(
              offset: Offset(0, -_animation.value),
              child: Icon(
                Icons.workspace_premium,
                size: 60,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 30),
            DotLoader(
      color:   primaryColor,
      size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
