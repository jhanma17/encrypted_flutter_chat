import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final IconData leading;
  final Function userTyped;
  final bool obscure;
  final TextInputType keyboard;

  const CustomTextInput(
      {Key? key,
      required this.hintText,
      required this.leading,
      required this.userTyped,
      required this.obscure,
      this.keyboard = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width * 0.70,
      child: TextField(
        //onChanged: userTyped,
        keyboardType: keyboard,
        onSubmitted: (value) {},
        onChanged: (val) => userTyped(val),
        autofocus: false,
        obscureText: obscure ? true : false,
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
      ),
    );
  }
}
