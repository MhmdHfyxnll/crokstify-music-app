import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Horizontal scrolling tabs for search result categories
class SearchCategoriesWidget extends StatelessWidget {
  final List<String> categories;
  final TabController tabController;

  const SearchCategoriesWidget({
    super.key,
    required this.categories,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorColor: theme.colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: categories.map((category) {
          return Tab(child: Text(category));
        }).toList(),
      ),
    );
  }
}
