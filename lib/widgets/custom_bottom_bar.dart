import 'package:flutter/material.dart';

/// Navigation item configuration for bottom bar
class _NavigationItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

/// Custom bottom navigation bar widget for music streaming app
/// Implements thumb-zone prioritized navigation with persistent mini-player support
///
/// Features:
/// - Fixed bottom positioning for one-handed operation
/// - Material 3 design with smooth transitions
/// - Active state indication with color and icon changes
/// - Optimized touch targets (minimum 48dp)
class CustomBottomBar extends StatefulWidget {
  /// Current active route path
  final String currentRoute;

  /// Callback when navigation item is tapped
  final Function(String route)? onNavigate;

  const CustomBottomBar({
    super.key,
    required this.currentRoute,
    this.onNavigate,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Navigation items mapped from Mobile Navigation Hierarchy
  static const List<_NavigationItem> _navigationItems = [
    _NavigationItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      route: '/home-dashboard',
    ),
    _NavigationItem(
      label: 'Search',
      icon: Icons.search_outlined,
      activeIcon: Icons.search_rounded,
      route: '/search-and-discovery',
    ),
    _NavigationItem(
      label: 'Library',
      icon: Icons.library_music_outlined,
      activeIcon: Icons.library_music_rounded,
      route: '/library-and-playlists',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int get _currentIndex {
    final index = _navigationItems.indexWhere(
      (item) => item.route == widget.currentRoute,
    );
    return index >= 0 ? index : 0;
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    // Trigger micro-feedback animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    final route = _navigationItems[index].route;

    if (widget.onNavigate != null) {
      widget.onNavigate!(route);
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
  decoration: BoxDecoration(
    color: colorScheme.surface,
    boxShadow: [
      BoxShadow(
        color: colorScheme.shadow.withValues(alpha: 0.08),
        offset: const Offset(0, -2),
        blurRadius: 8,
      ),
    ],
  ),
  child: SafeArea(
    top: false,
    child: SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _navigationItems.length,
            (index) => _buildNavigationItem(
              context,
              _navigationItems[index],
              index,
              _currentIndex == index,
            ),
          ),
        ),
      ),
    ),
  ),
  );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    _NavigationItem item,
    int index,
    bool isActive,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: AnimatedScale(
        scale: _currentIndex == index && _animationController.isAnimating
            ? 0.95
            : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isActive ? item.activeIcon : item.icon,
                    key: ValueKey(isActive),
                    size: 24,
                    color: isActive
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: isActive
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
