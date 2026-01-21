import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  double progress = 0.0;
  late AnimationController _logoController;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    // Logo scale animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_logoController);


    _logoController.forward();

    // Progress bar simulation
    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      setState(() {
        progress += 0.02;
      });

      if (progress >= 1) {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF66BB6A),
            ],
          ),
        ),
        child: Column(
          children: [

            const SizedBox(height: 60),

            // Title
            const Text(
              "CANE MANAGEMENT SYSTEM",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Logo
            ScaleTransition(
              scale: _logoScale,
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/canelogo.jpg",
                width: 350,
                height: 350,
                fit: BoxFit.contain,
              ),
            ),


            const SizedBox(height: 20),

            // Tagline
            const Text(
              "Secure • Track • Manage",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white38,
                valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),

            const Spacer(),

            // Footer
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Powered by Petals Infotech",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
