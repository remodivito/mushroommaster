import 'package:flutter/material.dart';
import 'package:mushroom_master/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerScreen extends StatelessWidget {
  final VoidCallback onAccept;

  const DisclaimerScreen({Key? key, required this.onAccept}) : super(key: key);

  static Future<bool> hasAcceptedDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('disclaimer_accepted') ?? false;
  }

  static Future<void> markDisclaimerAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('disclaimer_accepted', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: AppTheme.spacingL),
              const Text(
                "IMPORTANT SAFETY WARNING",
                style: TextStyle(
                  fontSize: AppTheme.fontSizeXL,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingL),
              const Text(
                "You should not eat anything you find in the wild. This app suggests potential mushroom species but is prone to making errors. Do not take action based on any suggestion offered by this app.",
                style: TextStyle(
                  fontSize: AppTheme.fontSizeM,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingL * 2),
              ElevatedButton(
                onPressed: () async {
                  await markDisclaimerAccepted();
                  onAccept();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingXL,
                    vertical: AppTheme.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                  ),
                ),
                child: const Text(
                  "I Understand and Agree",
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeM,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
