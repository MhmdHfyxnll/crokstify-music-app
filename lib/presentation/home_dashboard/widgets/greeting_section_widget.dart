import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Greeting section widget displaying personalized time-based greeting
/// Shows current time-based recommendations like 'Good Morning Mix'
class GreetingSectionWidget extends StatelessWidget {
  const GreetingSectionWidget({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  String _getRecommendation() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning Mix';
    if (hour < 17) return 'Afternoon Energy';
    if (hour < 21) return 'Evening Vibes';
    return 'Night Chill';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getGreeting(),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Your ${_getRecommendation()} is ready',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
