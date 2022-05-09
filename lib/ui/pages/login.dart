import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';
import '../widgets/custom_text_input.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<Login> {
  final AuthenticationController authenticationController = Get.find();
  String _email = '';
  String _password = '';
  bool _isLoginIn = false;

  Future<void> login() async {
    setState(() {
      _isLoginIn = true;
    });

    var result = await authenticationController.login(_email, _password);

    if (result == false) {
      _isLoginIn = false;
    }
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
                  hintText: 'Email',
                  leading: Icons.mail,
                  obscure: false,
                  keyboard: TextInputType.emailAddress,
                  userTyped: (val) {
                    updateEmail(val);
                  },
                ),
                const SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Contraseña',
                  leading: Icons.lock,
                  obscure: true,
                  userTyped: (val) {
                    updatePass(val);
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Hero(
                  tag: 'loginbutton',
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: _isLoginIn ? null : login,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Get.toNamed('/signup');
                    },
                    child: const Text(
                      'o crea una cuenta',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.deepPurple),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                const Hero(
                  tag: 'footer',
                  child: Text(
                    'Made in Colombia',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
