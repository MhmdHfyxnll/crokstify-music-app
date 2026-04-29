import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App bar variant types for different screen contexts
enum CustomAppBarVariant {
  /// Standard app bar with title and actions
  standard,

  /// Search-focused app bar with search field
  search,

  /// Minimal app bar for immersive content (music player)
  minimal,

  /// App bar with back button for secondary screens
  secondary,
}

/// Custom app bar widget for music streaming application
/// Implements Sonic Minimalism design with contextual variations
///
/// Features:
/// - Multiple variants for different screen contexts
/// - Smooth scroll-based elevation changes
/// - Consistent spacing and touch targets
/// - Profile avatar integration for settings access
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar variant type
  final CustomAppBarVariant variant;

  /// Title text (optional for minimal variant)
  final String? title;

  /// Leading widget (overrides default back button)
  final Widget? leading;

  /// Action widgets displayed on the right
  final List<Widget>? actions;

  /// Whether to show profile avatar (maps to settings)
  final bool showProfileAvatar;

  /// Callback when profile avatar is tapped
  final VoidCallback? onProfileTap;

  /// Search query text (for search variant)
  final String? searchQuery;

  /// Search callback (for search variant)
  final ValueChanged<String>? onSearchChanged;

  /// Whether app bar should be transparent
  final bool transparent;

  /// Custom background color (overrides theme)
  final Color? backgroundColor;

  /// Elevation value (0 for flat design)
  final double? elevation;

  const CustomAppBar({
    super.key,
    this.variant = CustomAppBarVariant.standard,
    this.title,
    this.leading,
    this.actions,
    this.showProfileAvatar = true,
    this.onProfileTap,
    this.searchQuery,
    this.onSearchChanged,
    this.transparent = false,
    this.backgroundColor,
    this.elevation,
  });

  /// Factory constructor for home/dashboard screen
  factory CustomAppBar.home({Key? key, VoidCallback? onProfileTap}) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.standard,
      title: 'Home',
      showProfileAvatar: true,
      onProfileTap: onProfileTap,
    );
  }

  /// Factory constructor for search screen
  factory CustomAppBar.search({
    Key? key,
    String? searchQuery,
    ValueChanged<String>? onSearchChanged,
    VoidCallback? onProfileTap,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.search,
      searchQuery: searchQuery,
      onSearchChanged: onSearchChanged,
      showProfileAvatar: true,
      onProfileTap: onProfileTap,
    );
  }

  /// Factory constructor for music player (minimal)
  factory CustomAppBar.player({Key? key, bool transparent = true}) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.minimal,
      transparent: transparent,
      showProfileAvatar: false,
      elevation: 0,
    );
  }

  /// Factory constructor for secondary screens
  factory CustomAppBar.secondary({
    Key? key,
    required String title,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.secondary,
      title: title,
      actions: actions,
      showProfileAvatar: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine background color
    final bgColor = transparent
        ? Colors.transparent
        : backgroundColor ?? colorScheme.surface;

    // Determine system overlay style based on background
    final overlayStyle = theme.brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;

    return AppBar(
      systemOverlayStyle: overlayStyle,
      backgroundColor: bgColor,
      elevation: elevation ?? (transparent ? 0 : null),
      scrolledUnderElevation: transparent ? 0 : 2,
      centerTitle: false,
      leading: _buildLeading(context),
      title: _buildTitle(context),
      actions: _buildActions(context),
      titleSpacing: leading == null && variant != CustomAppBarVariant.minimal
          ? 16
          : null,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    switch (variant) {
      case CustomAppBarVariant.minimal:
        return IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          iconSize: 28,
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Close',
        );

      case CustomAppBarVariant.secondary:
        return IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        );

      default:
        return null;
    }
  }

  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchField(context);

      case CustomAppBarVariant.minimal:
        return null;

      default:
        if (title == null) return null;
        return Text(title!, style: theme.appBarTheme.titleTextStyle);
    }
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchQuery != null
            ? TextEditingController(text: searchQuery)
            : null,
        onChanged: onSearchChanged,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search songs, artists, albums...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: searchQuery != null && searchQuery!.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () => onSearchChanged?.call(''),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final actionWidgets = <Widget>[];

    // Add custom actions if provided
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    // Add profile avatar for settings access (top-right placement)
    if (showProfileAvatar) {
      actionWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            onPressed:
                onProfileTap ??
                () {
                  Navigator.pushNamed(context, '/settings-and-profile');
                },
            tooltip: 'Profile & Settings',
          ),
        ),
      );
    }

    return actionWidgets.isEmpty ? null : actionWidgets;
  }
}
