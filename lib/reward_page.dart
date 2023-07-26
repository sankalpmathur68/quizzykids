import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzykids/homePage.dart';

class RewardPage extends StatelessWidget {
  final int totalReward;

  RewardPage({required this.totalReward});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/bg_1.jpg'), // Set the image path
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 6, sigmaY: 6), // Adjust blur strength here
              child: Container(
                  color: Colors.black
                      .withOpacity(0.1)), // Adjust opacity of the blur here
            ),
          ),
          Center(
            child: Container(
              height: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Congratulations!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Reward: $totalReward coins',
                    style: GoogleFonts.inter(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.black,
                          elevation: 1,
                          primary: Colors.purple.shade200,
                          minimumSize: Size(70, 50)),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Back to Home',
                        style: GoogleFonts.inter(
                            fontSize: 20, color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
