import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quizzykids/reward_page.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _score = 0;
  final String? userId = FirebaseAuth.instance.currentUser
      ?.uid; // Replace this with the user's unique ID or username
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('users');
  int _totalReward = 0;
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final questions = data['results'] as List<dynamic>;

      setState(() {
        _questions = questions.map((q) => Question.fromJson(q)).toList();
      });
    }
  }

  Future<int> getRewards() async {
    dynamic event = await _databaseReference.child('$userId').once();
    dynamic data = event.data?.snapshot.value;
    print(data);
    final value = event?.data.value; // Store the value in a variable
    return value != null ? value['rewards'] ?? 0 : 0;
  }

  Future<void> updateRewards(int newRewards) async {
    await _databaseReference.child("${userId}").update({'rewards': newRewards});
  }

  Future<void> addQuizRewards(int quizRewards) async {
    final currentRewards = await getRewards();
    final totalRewards = currentRewards + quizRewards;
    await updateRewards(totalRewards);
  }

  void _onAnswerSelected(int questionIndex, int selectedOptionIndex) {
    if (_questions.isNotEmpty && questionIndex < _questions.length) {
      final question = _questions[questionIndex];
      setState(() {
        if (_questions[questionIndex].correctOptionIndex ==
            selectedOptionIndex) {
          _score++;
          _totalReward += question.reward;
        }
        _questions[questionIndex].userResponse = selectedOptionIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isNotEmpty &&
        _questions.every((q) => q.userResponse != null)) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RewardPage(totalReward: _totalReward),
          ),
        );
      });
    }
    return Scaffold(
      extendBody: true,
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: Text('Quiz'),
      // ),
      body: _questions.isNotEmpty
          ? Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/bg_1.jpg'), // Set the image path
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5, sigmaY: 5), // Adjust blur strength here
                    child: Container(
                        color: Colors.black.withOpacity(
                            0.1)), // Adjust opacity of the blur here
                  ),
                ),
                PageView.builder(
                  itemCount: _questions.length,
                  onPageChanged: (page) {
                    // Save the user response when changing questions
                    if (_questions[page].userResponse != null) {
                      _questions[page].userResponse =
                          _questions[page].userResponse;
                    }
                  },
                  itemBuilder: (context, index) {
                    print(_questions[index].correctOptionIndex);
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            QuestionWidget(
                              question: _questions[index],
                              onAnswerSelected: (selectedOptionIndex) {
                                _onAnswerSelected(index, selectedOptionIndex);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  CupertinoIcons.back,
                                  size: 30,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.6), // Shadow color and opacity
                                      offset: Offset(
                                          0, 4), // Shadow position (x, y)
                                      blurRadius: 9, // Shadow blur radius
                                      spreadRadius: 10, // Shadow spread radius
                                    ),
                                  ],
                                ),
                                Text(
                                  "Swipe",
                                  style: GoogleFonts.shortStack(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  CupertinoIcons.forward,
                                  size: 30,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.6), // Shadow color and opacity
                                      offset: Offset(
                                          0, 4), // Shadow position (x, y)
                                      blurRadius: 9, // Shadow blur radius
                                      spreadRadius: 10, // Shadow spread radius
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Stack(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 150,
                                    color: Colors.deepPurple.shade400,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.6), // Shadow color and opacity
                                        offset: Offset(
                                            0, 6), // Shadow position (x, y)
                                        blurRadius: 5, // Shadow blur radius
                                        spreadRadius:
                                            20, // Shadow spread radius
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '${_totalReward}',
                                    style: GoogleFonts.shortStack(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final int reward;
  int? userResponse; // Updated to allow null value for user's response

  Question(
      this.questionText, this.options, this.correctOptionIndex, this.reward);

  factory Question.fromJson(Map<String, dynamic> json) {
    final options = (json['incorrect_answers'] as List<dynamic>)
        .map<String>((option) => option.toString())
        .toList();
    options.add(json['correct_answer']);
    final correctOptionIndex = json['correct_answer'].toString();
    final reward = json['difficulty'] == 'easy'
        ? 10
        : 20; // Set reward based on difficulty

    return Question(json['question'], options..shuffle(),
        options.indexOf(correctOptionIndex), reward);
  }
}

class QuestionWidget extends StatelessWidget {
  final Question question;
  final Function(int) onAnswerSelected;

  QuestionWidget({required this.question, required this.onAnswerSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.black38, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              question.questionText,
              style: GoogleFonts.shortStack(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          SizedBox(height: 10),
          for (int i = 0; i < question.options.length; i++)
            OptionWidget(
              question: question,
              optionText: question.options[i],
              isSelected: question.userResponse == i,
              isCorrect: i == question.correctOptionIndex,
              canAnswer: question.userResponse == null,
              correctOptionIndex: question.correctOptionIndex,
              onTap: () => onAnswerSelected(i),
            ),
        ],
      ),
    );
  }
}

class OptionWidget extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final bool isCorrect;
  final bool canAnswer;
  final int correctOptionIndex; // Add this variable
  final VoidCallback onTap;
  final Question question;
  OptionWidget({
    required this.question,
    required this.optionText,
    required this.isSelected,
    required this.isCorrect,
    required this.canAnswer,
    required this.correctOptionIndex, // Initialize it with the correct option index
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color optionColor = Colors.deepPurple.shade200;
    IconData iconData;
    String correctAnswer = '';

    if (isSelected) {
      if (isCorrect) {
        optionColor = Colors.green;
        iconData = Icons.check;
      } else {
        optionColor = Colors.red;
        iconData = Icons.close;
        correctAnswer =
            'Correct answer: ${question.options[question.correctOptionIndex]}';
      }
    } else {
      iconData = Icons.radio_button_unchecked;
    }
    return GestureDetector(
      onTap: canAnswer ? onTap : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: optionColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  iconData,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                SizedBox(width: 10),
                Container(
                  width: 200,
                  child: Text(
                    "$optionText",
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.shortStack(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            if (!isSelected && !canAnswer && isCorrect)
              Padding(
                padding: const EdgeInsets.only(top: 1.0, left: 16),
                child: Text(
                  'Correct answer: ${question.options[question.correctOptionIndex]}',
                  style: GoogleFonts.shortStack(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// import 'package:firebase_database/firebase_database.dart';

