import 'package:flutter/material.dart';
import 'package:notesapp/splash/splash1.dart';
import 'package:notesapp/services/settings_service.dart';
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
  runApp(const RestartWidget(child: MyApp()));
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SettingsService _settingsService = SettingsService();
  bool _darkMode = false;
  double _fontScale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final darkMode = await _settingsService.getDarkMode();
    final fontSize = await _settingsService.getFontSize();
    setState(() {
      _darkMode = darkMode;
      _fontScale = _settingsService.getFontSizeValue(fontSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Uas Note app",
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: _fontScale,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: _fontScale,
        ),
      ),
      home: const Splash1(),
    );
  }
}
