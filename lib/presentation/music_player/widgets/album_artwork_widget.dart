import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

/// Album artwork widget with parallax effect and gradient overlay
class AlbumArtworkWidget extends StatelessWidget {
  final String imageUrl;
  final String semanticLabel;
  final double parallaxOffset;

  const AlbumArtworkWidget({
    super.key,
    required this.imageUrl,
    required this.semanticLabel,
    this.parallaxOffset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 50.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Album artwork with parallax effect
          Transform.translate(
            offset: Offset(0, parallaxOffset * 20),
            child: CustomImageWidget(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 50.h,
              fit: BoxFit.cover,
              semanticLabel: semanticLabel,
            ),
          ),

          // Gradient overlay for better text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 20.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    theme.colorScheme.surface.withValues(alpha: 0.8),
                    theme.colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
