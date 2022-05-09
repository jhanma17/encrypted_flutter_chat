import 'package:flutter/material.dart';
import 'package:chat_app/ui/controllers/authentication_controller.dart';
import 'package:get/get.dart';

import 'package:chat_app/ui/widgets/custom_text_input.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<Signup> {
  final AuthenticationController authenticationController = Get.find();

  String _email = "";
  String _password = "";
  String _name = "";
  bool _isSigningUp = false;

  Future<void> signup() async {
    setState(() {
      _isSigningUp = true;
    });
    var result = false;

    try {
      result = await authenticationController.signup(_email, _password, _name);
    } catch (e) {
      print(e);
    }

    if (result == true) {
      Get.offAllNamed('/');
      return;
    }

    setState(() {
      _isSigningUp = false;
    });
  }

  void updateEmail(input) {
    setState(() {
      _email = input;
    });
  }

  void updatePass(input) {
    setState(() {
      _password = input;
    });
  }

  void updateName(input) {
    setState(() {
      _name = input;
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
                  userTyped: (value) => updateName(value),
                ),
                const SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Email',
                  leading: Icons.mail,
                  keyboard: TextInputType.emailAddress,
                  obscure: false,
                  userTyped: (value) => updateEmail(value),
                ),
                const SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Contraseña',
                  leading: Icons.lock,
                  keyboard: TextInputType.visiblePassword,
                  obscure: true,
                  userTyped: (value) => updatePass(value),
                ),
                const SizedBox(
                  height: 30,
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
