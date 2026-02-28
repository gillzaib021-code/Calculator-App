import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Color? color;
  final VoidCallback onPressed;

  const MyButton({
    super.key,
    required this.title,
    this.color,
    required this.onPressed,
  });

  bool isOperator(String x) {
    return ['/', '*', '-', '+', '='].contains(x);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[850],
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: onPressed,
          child: FittedBox(
            child: Text(
              title,
              style: TextStyle(
                fontSize: isOperator(title) ? 30 : 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
