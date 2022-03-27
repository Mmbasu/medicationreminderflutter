import 'package:flutter/material.dart';

class myPasswordTextField extends StatelessWidget {
  const myPasswordTextField({Key? key, required this.text, required TextEditingController controller}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey[400]),

      ),
    );
  }
}

class myTextField extends StatelessWidget {
  const myTextField({Key? key, required this.text, required TextEditingController controller}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }
}
