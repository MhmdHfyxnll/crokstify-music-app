import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Secondary controls widget for shuffle, repeat, queue, and options
class SecondaryControlsWidget extends StatelessWidget {
  final bool isShuffleEnabled;
  final String repeatMode; // 'off', 'all', 'one'
  final VoidCallback onShuffleToggle;
  final VoidCallback onRepeatToggle;
  final VoidCallback onQueueTap;
  final VoidCallback onOptionsTap;

  const SecondaryControlsWidget({
    super.key,
    required this.isShuffleEnabled,
    required this.repeatMode,
    required this.onShuffleToggle,
    required this.onRepeatToggle,
    required this.onQueueTap,
    required this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Shuffle button
          IconButton(
            icon: CustomIconWidget(
              iconName: 'shuffle_rounded',
              color: isShuffleEnabled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: onShuffleToggle,
            tooltip: 'Shuffle',
          ),

          // Repeat button
          IconButton(
            icon: CustomIconWidget(
              iconName: repeatMode == 'one'
                  ? 'repeat_one_rounded'
                  : 'repeat_rounded',
              color: repeatMode != 'off'
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: onRepeatToggle,
            tooltip: 'Repeat',
          ),

          // Queue button
          IconButton(
            icon: CustomIconWidget(
              iconName: 'queue_music_rounded',
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: onQueueTap,
            tooltip: 'Queue',
          ),

          // Options menu button
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert_rounded',
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: onOptionsTap,
            tooltip: 'More options',
          ),
        ],
      ),
    );
  }
}
