import 'package:flutter/material.dart';


class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
        required this.color,
        required this.pressed,
        required this.title});

  final Color color;
  final VoidCallback pressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        elevation: 10,
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          onPressed: pressed,
          minWidth: 200,
          height: 40,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
