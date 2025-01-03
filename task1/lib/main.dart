import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var userQuestion = '';
  var userAnswer = '';

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          // Display Area
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    userQuestion,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    userAnswer,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Buttons Grid
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    // Clear Button
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userQuestion = '';
                          userAnswer = '';
                        });
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      buttonText: buttons[index],
                    );
                  } else if (index == 1) {
                    // Delete Button
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          if (userQuestion.isNotEmpty) {
                            userQuestion = userQuestion.substring(
                                0, userQuestion.length - 1);
                          }
                        });
                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      buttonText: buttons[index],
                    );
                  } else if (index == buttons.length - 1) {
                    // Equals Button
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          equalpressed();
                        });
                      },
                      color: Colors.deepPurple,
                      textColor: Colors.white,
                      buttonText: buttons[index],
                    );
                  } else {
                    // Other Buttons
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userQuestion += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: isOperator(buttons[index])
                          ? Colors.deepPurple
                          : Colors.deepPurple[100]!,
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : Colors.deepPurple,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String button) {
    return button == '%' ||
        button == '/' ||
        button == 'x' ||
        button == '-' ||
        button == '+' ||
        button == '=';
  }

  void equalpressed() {
    String finalQuestion = userQuestion;

    // Replace 'x' with '*' and handle other transformations
    finalQuestion = finalQuestion.replaceAll('x', '*');
    finalQuestion = finalQuestion.replaceAll('%', '/100');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      userAnswer = eval.toString();
    } catch (e) {
      userAnswer = "Error";
    }
  }
}
