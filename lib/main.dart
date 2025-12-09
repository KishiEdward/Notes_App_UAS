import 'package:flutter/material.dart';
import 'package:notesapp/splash/splash1.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:notesapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Firebase Init Failed: $e", textAlign: TextAlign.center),
        ),
      ),
    ));
    return;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Uas Note app",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const Splash1(),
    );
  }
}
