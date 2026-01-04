import 'package:flutter/material.dart';
import 'package:notesapp/services/settings_service.dart';
import 'package:notesapp/services/fcm_service.dart';
import 'package:notesapp/utils/fcm_background_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notesapp/firebase_options.dart';
import 'package:notesapp/widgets/auth_wrapper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:showcaseview/showcaseview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }
  } catch (e) {}
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
    return KeyedSubtree(key: key, child: widget.child);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SettingsService _settingsService = SettingsService();
  bool _darkMode = false;
  double _fontScale = 1.0;
  final FCMService _fcmService = FCMService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    await _fcmService.initialize();
    _fcmService.setupForegroundHandler();
  }

  Future<void> _loadSettings() async {
    final darkMode = await _settingsService.getDarkMode();
    final fontSize = await _settingsService.getFontSize();
    setState(() {
      _darkMode = darkMode;
      _fontScale = _settingsService.getFontSizeValue(fontSize);
    });
  }

  void changeTheme(bool isDark) {
    setState(() {
      _darkMode = isDark;
    });
  }

  void changeFontSize(double newScale) {
    setState(() {
      _fontScale = newScale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NekoMind",
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,

      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return ShowCaseWidget(
          builder: (context) => MediaQuery(
            data: mediaQueryData.copyWith(
              textScaler: TextScaler.linear(_fontScale),
            ),
            child: child!,
          ),
        );
      },

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),

      home: const AuthWrapper(),
    );
  }
}
