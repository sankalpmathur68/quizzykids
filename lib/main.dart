import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzykids/auth_page.dart';
import 'package:quizzykids/firebase_options.dart';
import 'package:quizzykids/homePage.dart';
import 'package:quizzykids/quiz_page.dart';
import 'package:quizzykids/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splashScreen',
      routes: {
        '/': (context) => FirebaseAuth.instance.currentUser?.uid != null
            ? HomePage()
            : AuthenticationPage(),
        "/splashScreen": (context) => splashScreen()
      },
    );
  }
}

class RewardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // int rewardPoints = getRewardPoints(); // Implement this function to retrieve the points from SharedPreferences
    return Scaffold(
      appBar: AppBar(title: Text('Reward Screen')),
      body: Center(
        child: Text('You have  points!'),
      ),
    );
  }
}
