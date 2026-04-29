import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

/// Made for you playlists carousel widget
/// Displays personalized playlists curated for the user
class MadeForYouWidget extends StatelessWidget {
  const MadeForYouWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> madeForYou = [
      {
        "id": 1,
        "title": "Daily Mix 1",
        "description": "Luna Eclipse, The Weeknd, and more",
        "image": "https://images.unsplash.com/photo-1693963307509-a9b686d1dda8",
        "semanticLabel":
            "Colorful abstract gradient playlist cover with pink and blue waves",
      },
      {
        "id": 2,
        "title": "Discover Weekly",
        "description": "Your weekly mixtape of fresh music",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_13e77f655-1765723175602.png",
        "semanticLabel":
            "Dark purple playlist cover with geometric patterns and music notes",
      },
      {
        "id": 3,
        "title": "Release Radar",
        "description": "New music from artists you follow",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_187d0d218-1767091326325.png",
        "semanticLabel":
            "Bright red and orange gradient with radar wave pattern",
      },
      {
        "id": 4,
        "title": "Your Top Songs 2025",
        "description": "Your most played tracks this year",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_12bba957f-1767272418802.png",
        "semanticLabel": "Golden yellow cover with sparkles and music symbols",
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
                'Made For You',
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
          height: 26.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            scrollDirection: Axis.horizontal,
            itemCount: madeForYou.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final item = madeForYou[index];
              return _buildMadeForYouItem(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMadeForYouItem(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/music-player');
      },
      child: Container(
        width: 40.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                imageUrl: item["image"] as String,
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover,
                semanticLabel: item["semanticLabel"] as String,
              ),
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
              item["description"] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
