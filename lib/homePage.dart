import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              wallet(),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
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
            ],
          ),
        ),
      ),
    );
  }
}

Widget wallet() {
  return StreamBuilder(
      stream: FirebaseDatabase.instance.ref("users").onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> event) {
        dynamic data = event.data?.snapshot.value;
        final String? userId = FirebaseAuth.instance.currentUser?.uid;
        final totalRewards;
        if (data != null) {
          totalRewards =
              data['$userId'] != null ? data['$userId']['rewards'] : 0;
        } else {
          totalRewards = 0;
        }
        return Card(
          elevation: 1,
          color: Colors.purple.shade200,
          surfaceTintColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  'Total Rewards:',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '$totalRewards points',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      });
}
