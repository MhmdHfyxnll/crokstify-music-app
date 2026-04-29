import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Trending now carousel widget
/// Displays currently trending songs and albums
class TrendingNowWidget extends StatelessWidget {
  const TrendingNowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> trending = [
      {
        "id": 1,
        "title": "Blinding Lights",
        "artist": "The Weeknd",
        "plays": "2.5M",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_18ba9039d-1765431876796.png",
        "semanticLabel":
            "Retro 80s style album cover with neon purple and pink lights",
      },
      {
        "id": 2,
        "title": "Levitating",
        "artist": "Dua Lipa",
        "plays": "2.1M",
        "image": "https://images.unsplash.com/photo-1661111966553-8843a4ad28ce",
        "semanticLabel":
            "Futuristic disco ball with colorful light reflections",
      },
      {
        "id": 3,
        "title": "Good 4 U",
        "artist": "Olivia Rodrigo",
        "plays": "1.8M",
        "image": "https://images.unsplash.com/photo-1695088647205-3687214bf0b6",
        "semanticLabel":
            "Punk rock aesthetic with graffiti and electric guitar",
      },
      {
        "id": 4,
        "title": "Stay",
        "artist": "The Kid LAROI & Justin Bieber",
        "plays": "1.6M",
        "image": "https://images.unsplash.com/photo-1615103634730-df8aef6b2ff2",
        "semanticLabel": "Moody urban rooftop scene at golden hour",
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
                'Trending Now',
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
            itemCount: trending.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final item = trending[index];
              return _buildTrendingItem(context, item, index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingItem(
    BuildContext context,
    Map<String, dynamic> item,
    int rank,
  ) {
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
                  left: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$rank',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'trending_up',
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          item["plays"] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
}
