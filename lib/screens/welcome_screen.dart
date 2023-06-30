import 'package:chatapp/screens/registration_screen.dart';
import 'package:chatapp/screens/sigin_screen.dart';
import 'package:flutter/material.dart';


import '../widget/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = "welcome_screen";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  child: Image.asset("images/logo.png"),
                ),
                const Text(
                  "Message Me",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color(0Xff2e386b)),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(
              color: Colors.yellow[900]!,
              pressed: () {
                Navigator.pushNamed(context, SignInScreen.screenRoute);
              },
              title: "Sign in",
            ),
            const SizedBox(
              height: 25,
            ),
            MyButton(
              color: Colors.blue[900]!,
              pressed: () {
                Navigator.pushNamed(context, RegistrationScreen.screenRoute);
              },
              title: "Register",
            ),
          ],
        ),
      ),
    );
  }
}
