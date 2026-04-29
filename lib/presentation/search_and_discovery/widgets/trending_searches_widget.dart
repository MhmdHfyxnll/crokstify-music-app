import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget displaying trending searches with trend indicators
class TrendingSearchesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> trendingSearches;
  final ValueChanged<String> onSearchTap;

  const TrendingSearchesWidget({
    super.key,
    required this.trendingSearches,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Searches',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: trendingSearches.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final search = trendingSearches[index];
              return _buildTrendingItem(context, search, index + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingItem(
    BuildContext context,
    Map<String, dynamic> search,
    int rank,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onSearchTap(search['query'] as String),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Rank number
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: rank <= 3
                    ? theme.colorScheme.primary.withValues(alpha: 0.2)
                    : theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: rank <= 3
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Search query and artist
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    search['query'] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    search['artist'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 2.w),

            // Trend indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomIconWidget(
                  iconName: search['trend'] == 'up'
                      ? 'trending_up'
                      : search['trend'] == 'down'
                      ? 'trending_down'
                      : 'trending_flat',
                  color: search['trend'] == 'up'
                      ? Colors.green
                      : search['trend'] == 'down'
                      ? Colors.red
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  search['searches'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
