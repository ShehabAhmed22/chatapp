import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/registration_screen.dart';
import 'package:chatapp/screens/sigin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _auth =FirebaseAuth.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message me',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute: _auth.currentUser!=null?ChatScreen.screenRoute:WelcomeScreen.screenRoute,
      routes: {
        WelcomeScreen.screenRoute:(context)=>const WelcomeScreen(),
        SignInScreen.screenRoute:(context)=>const SignInScreen(),
        RegistrationScreen.screenRoute:(context)=>const RegistrationScreen(),
        ChatScreen.screenRoute:(context)=>const ChatScreen(),
      },
    );
  }
}


