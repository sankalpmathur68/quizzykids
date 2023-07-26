import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizzykids/quiz_page.dart';

class AuthenticationPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        return authResult.user;
      }
    } catch (e) {
      // Handle sign-in errors
      print("Error signing in: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // appBar: AppBar(title: Text('Sign In')),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/bg_2.jpg'), // Set the image path
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 3, sigmaY: 3), // Adjust blur strength here
              child: Container(
                  color: Colors.black
                      .withOpacity(0.1)), // Adjust opacity of the blur here
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 150,
                // ),
                Image.asset("assets/images/logo.png"),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 1,
                      primary: Colors.purple.shade200,
                      minimumSize: Size(70, 50)),
                  onPressed: () async {
                    User? user = await _handleSignIn();

                    if (user != null) {
                      // User successfully signed in, navigate to the quiz page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => QuizPage()),
                      );
                    } else {
                      // Show a message or snackbar indicating sign-in failure
                    }
                  },
                  child: Text(
                    'Sign In with Google',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
