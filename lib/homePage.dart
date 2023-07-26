import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzykids/auth_page.dart';
import 'package:quizzykids/quiz_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.logout,
            color: Colors.purple.shade400,
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthenticationPage()),
            );
          }),

      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: Text(
      //     'Quizz kids',
      //     style: GoogleFonts.inter(
      //         fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   centerTitle: true,
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_1.jpg'), // Set the image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                elevation: 1,
                primary: Colors.purple.shade200,
                minimumSize: Size(70, 70)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizPage()),
              );
            },
            child: Text(
              'Start Quiz',
              style: GoogleFonts.inter(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
