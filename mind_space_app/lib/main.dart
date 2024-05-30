import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import './views/pages/auth_page.dart';
import './views/pages/home_page.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDDY5d2rM3MtGKuXy7VUrET0_H9hjbn5gY",
      authDomain: "mind-space-cf491.firebaseapp.com",
      projectId: "mind-space-cf491",
      storageBucket: "mind-space-cf491.appspot.com",
      messagingSenderId: "458649774710",
      appId: "1:458649774710:web:172e2a30da9b22c6facd57",
      measurementId: "G-MLFE2ZRB4N",
    ),
  ); // initializing firebase

  await dotenv.load(fileName: '.env');
  runApp(
    const MyApp(), // Wrap your app
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0),
        textTheme: TextTheme(
          displaySmall: TextStyle(color: Colors.black, fontSize: 14),
          displayLarge: TextStyle(
              color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: Image.asset("assets/applogo.png"));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return AuthPage();
          }
        }),
      ),
    );
  }
}
