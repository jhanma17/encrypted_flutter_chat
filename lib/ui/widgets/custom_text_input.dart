import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final IconData leading;
  final bool obscure;

  final TextInputType keyboard;

  final TextEditingController controller;

  const CustomTextInput(
      {Key? key,
      required this.hintText,
      required this.leading,
      required this.obscure,
      required this.controller,
      required this.keyboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      width: MediaQuery.of(context).size.width * 0.70,
      padding: const EdgeInsets.only(left: 20),
      child: TextFormField(
        key: const Key('loginPassord'),
        controller: controller,
        keyboardType: keyboard,
        obscureText: obscure,
        decoration: InputDecoration(
          icon: Icon(
            leading,
            color: Colors.deepPurple,
          ),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        validator: (value) {},
      ),
    );
  }
}
