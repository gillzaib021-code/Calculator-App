import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'my_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String userInput = '';
  String answer = '';
  List<String> history = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: showHistory,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// DISPLAY AREA
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// INPUT (TOP - RIGHT)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        userInput,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // /// DIVIDER LINE
                    // Container(
                    //   height: 1,
                    //   width: double.infinity,
                    //   color: Colors.white24,
                    // ),

                    const SizedBox(height: 12),

                    /// ANSWER (BOTTOM - RIGHT)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        answer,
                        textAlign: TextAlign.right,
                        maxLines: 4,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// BUTTONS
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  buttonRow(['AC', '+/-', '%', '/']),
                  buttonRow(['7', '8', '9', '*']),
                  buttonRow(['4', '5', '6', '-']),
                  buttonRow(['1', '2', '3', '+']),
                  buttonRow(['0', '.', 'DEL', '=']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonRow(List<String> texts) {
    return Row(
      children: texts.map((text) {
        return MyButton(
          title: text,
          color: isOperator(text) ? const Color(0xffffa00a) : null,
          onPressed: () => onButtonPressed(text),
        );
      }).toList(),
    );
  }

  bool isOperator(String x) {
    return ['/', '*', '-', '+', '='].contains(x);
  }

  void onButtonPressed(String text) {
    setState(() {
      if (text == 'AC') {
        userInput = '';
        answer = '';
      } else if (text == 'DEL') {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
      } else if (text == '=') {
        calculate();
      } else {
        userInput += text;
      }
    });
  }

  void calculate() {
    if (userInput.isEmpty) return;

    try {
      String finalInput = userInput;

      if (RegExp(r'[+\-*/.]$').hasMatch(finalInput)) {
        finalInput =
            finalInput.substring(0, finalInput.length - 1);
      }

      Parser parser = Parser();
      Expression exp = parser.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        answer =
            eval % 1 == 0 ? eval.toInt().toString() : eval.toString();
        history.add('$userInput = $answer');
      });
    } catch (e) {
      setState(() {
        answer = 'Error';
      });
    }
  }

  void showHistory() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title:
            const Text('History', style: TextStyle(color: Colors.white)),
        content: history.isEmpty
            ? const Text(
                'No history yet',
                style: TextStyle(color: Colors.white54),
              )
            : SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (_, i) => Text(
                    history[i],
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => history.clear());
              Navigator.pop(context);
            },
            child:
                const Text('Clear', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
