import 'package:flutter/material.dart';
import 'package:chat_app/ui/controllers/authentication_controller.dart';
import 'package:get/get.dart';

import 'package:chat_app/ui/widgets/custom_text_input.dart';
import 'package:loggy/loggy.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<Signup> {
  final AuthenticationController authenticationController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isSigningUp = false;

  Future<void> signup() async {
    setState(() {
      _isSigningUp = true;
    });

    try {
      await authenticationController.signup(_emailController.text,
          _passwordController.text, _nameController.text);
      Get.offAllNamed('/');
      return;
    } catch (e) {
      logInfo('Error en signup: $e');
    }

    setState(() {
      _isSigningUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'heroicon',
                  child: Icon(
                    Icons.textsms,
                    size: 120,
                    color: Colors.deepPurple[900],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Hero(
                  tag: 'HeroTitle',
                  child: Text(
                    'Secret Chatter',
                    style: TextStyle(
                        color: Colors.deepPurple[900],
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                CustomTextInput(
                  hintText: 'Nombre',
                  leading: Icons.text_format,
                  obscure: false,
                  controller: _nameController,
                  keyboard: TextInputType.text,
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomTextInput(
                  hintText: 'Email',
                  leading: Icons.mail,
                  keyboard: TextInputType.emailAddress,
                  obscure: false,
                  controller: _emailController,
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomTextInput(
                  hintText: 'Contraseña',
                  leading: Icons.lock,
                  keyboard: TextInputType.visiblePassword,
                  obscure: true,
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 10,
                ),
                Hero(
                    tag: 'signupbutton',
                    child: ElevatedButton(
                      child: const Text('Signup'),
                      onPressed: _isSigningUp ? null : signup,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
