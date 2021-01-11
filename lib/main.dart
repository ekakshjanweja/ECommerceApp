import 'package:ecommerce_app/screens/HomePage.dart';
import 'package:ecommerce_app/screens/LandingPage.dart';
import 'package:ecommerce_app/screens/LogInPage.dart';
import 'package:ecommerce_app/screens/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        accentColor: const Color(0xFFFF1E00),
      ),
      routes: {
        '/Home': (context) => HomePage(),
        '/LogIn': (context) => LogIn(),
        '/SignUp': (context) => SignUp(),
      },
    );
  }
}
