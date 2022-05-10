import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../controllers/authentication_controller.dart';
import '../widgets/custom_text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthenticationController authenticationController = Get.find();

  bool _isLoginIn = false;

  Future<void> login() async {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _isLoginIn = true;
    });

    try {
      await authenticationController.login(
          _emailController.text, _passwordController.text);
      return;
    } catch (e) {
      logInfo('Error in login: $e');
    }

    setState(() {
      _isLoginIn = false;
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
                const Text(
                  "Login with email",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextInput(
                  hintText: 'Correo del usuario',
                  leading: Icons.person,
                  obscure: false,
                  controller: _emailController,
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomTextInput(
                  hintText: 'Password',
                  leading: Icons.lock,
                  obscure: true,
                  controller: _passwordController,
                  keyboard: TextInputType.text,
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
