import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget displaying recent search history as dismissible chips
class RecentSearchesWidget extends StatelessWidget {
  final List<String> searches;
  final ValueChanged<String> onSearchTap;
  final ValueChanged<String> onSearchRemove;

  const RecentSearchesWidget({
    super.key,
    required this.searches,
    required this.onSearchTap,
    required this.onSearchRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Text(
            'Recent Searches',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: searches.map((search) {
              return _buildSearchChip(context, search);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(BuildContext context, String search) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onSearchTap(search),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'history',
              color: theme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            SizedBox(width: 2.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 40.w),
              child: Text(
                search,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 2.w),
            InkWell(
              onTap: () => onSearchRemove(search),
              child: CustomIconWidget(
                iconName: 'close',
                color: theme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
