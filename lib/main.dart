import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:system_alert_window/system_alert_window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen Reader Bubble',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Deep Indigo
          secondary: const Color(0xFF00BFA5), // Vibrant Teal
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool isServiceRunning = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  void _requestPermissions() async {
    await SystemAlertWindow.requestPermissions();
  }

  void _toggleBubble() async {
    if (isServiceRunning) {
      await SystemAlertWindow.closeSystemWindow();
      setState(() => isServiceRunning = false);
    } else {
      await SystemAlertWindow.showSystemWindow(
        height: 100,
        width: 100,
        gravity: SystemWindowGravity.TOP,
      );
      setState(() => isServiceRunning = true);
    }
  }

  void _speakSampleText() async {
    await flutterTts.setLanguage("ur-PK"); // آف لائن اردو/انگریزی آواز
    await flutterTts.speak("یہ ایک آزمائشی آواز ہے");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Reader'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _toggleBubble,
              icon: const Icon(Icons.bubble_chart),
              label: Text(isServiceRunning ? 'ببل بند کریں' : 'فلوٹنگ ببل آن کریں'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: _speakSampleText,
              child: const Text('آواز چیک کریں (TTS Test)'),
            ),
          ],
        ),
      ),
    );
  }
}
