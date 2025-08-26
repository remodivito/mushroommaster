import 'package:flutter/material.dart';
import 'package:mushroom_master/app/app.dart';
import 'package:mushroom_master/disclaimer/disclaimer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool _showDisclaimer = true;

  @override
  void initState() {
    super.initState();
  }

  void _handleDisclaimerAccepted() {
    setState(() {
      _showDisclaimer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showDisclaimer) {
      return MaterialApp(
        home: DisclaimerScreen(onAccept: _handleDisclaimerAccepted),
      );
    }

    return const MyApp();
  }
}