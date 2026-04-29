import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

/// New releases carousel widget
/// Displays latest album and single releases
class NewReleasesWidget extends StatelessWidget {
  const NewReleasesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> newReleases = [
      {
        "id": 1,
        "title": "Starlight",
        "artist": "Taylor Swift",
        "type": "Album",
        "image": "https://images.unsplash.com/photo-1630274020036-98f7b8e76eb4",
        "semanticLabel":
            "Album cover with starry night sky and silhouette of woman in flowing dress",
      },
      {
        "id": 2,
        "title": "Neon Nights",
        "artist": "The Weeknd",
        "type": "Single",
        "image": "https://images.unsplash.com/photo-1671877298381-2aeaa4a45b96",
        "semanticLabel":
            "Neon pink and blue city lights reflected on wet streets at night",
      },
      {
        "id": 3,
        "title": "Echoes",
        "artist": "Billie Eilish",
        "type": "Album",
        "image": "https://images.unsplash.com/photo-1542850182-cdc7d5fc91c9",
        "semanticLabel":
            "Minimalist black and white portrait with dramatic shadows",
      },
      {
        "id": 4,
        "title": "Summer Love",
        "artist": "Ed Sheeran",
        "type": "Single",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_15d3ec6a9-1764851142812.png",
        "semanticLabel":
            "Warm sunset beach scene with acoustic guitar in foreground",
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
                'New Releases',
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
          height: 28.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            scrollDirection: Axis.horizontal,
            itemCount: newReleases.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final item = newReleases[index];
              return _buildNewReleaseItem(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewReleaseItem(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/music-player');
      },
      child: Container(
        width: 42.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: item["image"] as String,
                    width: 42.w,
                    height: 42.w,
                    fit: BoxFit.cover,
                    semanticLabel: item["semanticLabel"] as String,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'NEW',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    item["artist"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  ' • ${item["type"]}',
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
