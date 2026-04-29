import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Primary playback controls widget
class PlaybackControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PlaybackControlsWidget({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          IconButton(
            icon: CustomIconWidget(
              iconName: 'skip_previous_rounded',
              color: theme.colorScheme.onSurface,
              size: 40,
            ),
            onPressed: onPrevious,
            tooltip: 'Previous',
            iconSize: 40,
          ),

          SizedBox(width: 8.w),

          // Play/Pause button
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: CustomIconWidget(
                iconName: isPlaying ? 'pause_rounded' : 'play_arrow_rounded',
                color: theme.colorScheme.onPrimary,
                size: 36,
              ),
              onPressed: onPlayPause,
              tooltip: isPlaying ? 'Pause' : 'Play',
              iconSize: 36,
            ),
          ),

          SizedBox(width: 8.w),

          // Next button
          IconButton(
            icon: CustomIconWidget(
              iconName: 'skip_next_rounded',
              color: theme.colorScheme.onSurface,
              size: 40,
            ),
            onPressed: onNext,
            tooltip: 'Next',
            iconSize: 40,
          ),
        ],
      ),
    );
  }
}
