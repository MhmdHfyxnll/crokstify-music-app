import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Settings section widget for grouping related settings
///
/// Features:
/// - Section title with consistent styling
/// - Grouped settings items
/// - Native platform styling support
/// - Dividers between items
class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
          ),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(children: _buildChildrenWithDividers(context)),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> widgets = [];

    for (int i = 0; i < children.length; i++) {
      widgets.add(children[i]);

      if (i < children.length - 1) {
        widgets.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: 4.w,
            endIndent: 4.w,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        );
      }
    }

    return widgets;
  }
}
