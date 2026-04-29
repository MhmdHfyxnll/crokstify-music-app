import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Recently played carousel widget
/// Displays horizontal scrolling list of recently played albums/tracks
class RecentlyPlayedWidget extends StatelessWidget {
  const RecentlyPlayedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> recentlyPlayed = [
      {
        "id": 1,
        "title": "Midnight Dreams",
        "artist": "Luna Eclipse",
        "image": "https://images.unsplash.com/photo-1687560466164-1eeddb3b119b",
        "semanticLabel":
            "Album cover showing a purple and blue gradient with abstract geometric shapes",
      },
      {
        "id": 2,
        "title": "Summer Vibes",
        "artist": "The Beach Boys Revival",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_1c16ec04a-1766159377634.png",
        "semanticLabel":
            "Bright yellow and orange album cover with tropical palm tree silhouettes",
      },
      {
        "id": 3,
        "title": "Urban Beats",
        "artist": "Metro Sound",
        "image": "https://images.unsplash.com/photo-1710776684853-bfb6de5e3c1e",
        "semanticLabel":
            "Dark urban cityscape at night with neon lights and skyscrapers",
      },
      {
        "id": 4,
        "title": "Acoustic Sessions",
        "artist": "James Morrison",
        "image": "https://images.unsplash.com/photo-1674824043348-7dd35ef520e7",
        "semanticLabel":
            "Warm brown toned image of acoustic guitar against wooden background",
      },
      {
        "id": 5,
        "title": "Electronic Pulse",
        "artist": "DJ Nexus",
        "image": "https://images.unsplash.com/photo-1548502632-6b93092aad0b",
        "semanticLabel":
            "Futuristic blue and pink neon lights with electronic music equipment",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Played',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 22.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            scrollDirection: Axis.horizontal,
            itemCount: recentlyPlayed.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final item = recentlyPlayed[index];
              return _buildRecentlyPlayedItem(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayedItem(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/music-player');
      },
      onLongPress: () {
        _showContextMenu(context, item);
      },
      child: Container(
        width: 35.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: item["image"] as String,
                    width: 35.w,
                    height: 35.w,
                    fit: BoxFit.cover,
                    semanticLabel: item["semanticLabel"] as String,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: CustomIconWidget(
                      iconName: 'play_arrow',
                      color: theme.colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              item["title"] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.3.h),
            Text(
              item["artist"] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'playlist_add',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Add to Playlist'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Share'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Go to Artist'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
