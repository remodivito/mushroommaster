import 'package:flutter/material.dart';
import 'package:mushroom_master/utils/theme.dart';

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.spacingM),
      child: Center(
        child: SizedBox(
          height: 32,
          width: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}
