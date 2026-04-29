import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Segmented control for switching between library sections
class SegmentControlWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSegmentChanged;
  final List<String> segments;

  const SegmentControlWidget({
    super.key,
    required this.selectedIndex,
    required this.onSegmentChanged,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(0.5.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(
          segments.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onSegmentChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    segments[index],
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: selectedIndex == index
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: selectedIndex == index
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
