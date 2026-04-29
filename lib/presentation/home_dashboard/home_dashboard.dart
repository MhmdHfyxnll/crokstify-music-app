import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/greeting_section_widget.dart';
import './widgets/made_for_you_widget.dart';
import './widgets/mini_player_widget.dart';
import './widgets/new_releases_widget.dart';
import './widgets/recently_played_widget.dart';
import './widgets/trending_now_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  bool _showMiniPlayer = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isRefreshing = false);
  }

  void _handleVoiceSearch() {
    Navigator.pushNamed(context, '/search-and-discovery');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: CustomAppBar.home(
        onProfileTap: () {
          Navigator.pushNamed(context, '/settings-and-profile');
        },
      ),

      /// BODY
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.h),

                  const GreetingSectionWidget(),

                  SizedBox(height: 2.h),

                  _buildSearchBar(context),

                  SizedBox(height: 3.h),

                  const RecentlyPlayedWidget(),

                  SizedBox(height: 3.h),

                  const MadeForYouWidget(),

                  SizedBox(height: 3.h),

                  const NewReleasesWidget(),

                  SizedBox(height: 3.h),

                  const TrendingNowWidget(),

                  /// ruang bawah supaya tidak ketutup mini player
                  SizedBox(height: _showMiniPlayer ? 16.h : 4.h),
                ],
              ),
            ),
          ],
        ),
      ),

      /// MIC BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: _handleVoiceSearch,
        backgroundColor: theme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'mic',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
      ),

      /// MINI PLAYER + NAVBAR
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showMiniPlayer)
            const MiniPlayerWidget(),

          CustomBottomBar(
            currentRoute: '/home-dashboard',
            onNavigate: (route) {
              Navigator.pushNamed(context, route);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/search-and-discovery');
        },
        child: Container(
          height: 6.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              SizedBox(width: 4.w),

              CustomIconWidget(
                iconName: 'search',
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),

              SizedBox(width: 3.w),

              Expanded(
                child: Text(
                  'Search songs, artists, albums...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              IconButton(
                icon: CustomIconWidget(
                  iconName: 'mic',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                onPressed: _handleVoiceSearch,
              ),

              SizedBox(width: 2.w),
            ],
          ),
        ),
      ),
    );
  }
}