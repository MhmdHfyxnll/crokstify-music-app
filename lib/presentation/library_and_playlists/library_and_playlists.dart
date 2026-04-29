import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/library_header_widget.dart';
import './widgets/playlist_card_widget.dart';
import './widgets/segment_control_widget.dart';
import './widgets/storage_info_widget.dart';

/// Library and Playlists screen - Main music library management interface
class LibraryAndPlaylists extends StatefulWidget {
  const LibraryAndPlaylists({super.key});

  @override
  State<LibraryAndPlaylists> createState() => _LibraryAndPlaylistsState();
}

class _LibraryAndPlaylistsState extends State<LibraryAndPlaylists> {
  int _selectedSegment = 0;
  String _searchQuery = '';
  String _sortOption = 'Recently Added';
  bool _isRefreshing = false;

  final List<String> _segments = [
    'Your Music',
    'Made for You',
    'Recently Played',
    'Downloaded',
  ];

  final List<String> _sortOptions = [
    'Recently Added',
    'Alphabetical',
    'Most Played',
    'Custom Order',
  ];

  // Mock data for playlists
  final List<Map<String, dynamic>> _allPlaylists = [
    {
      "id": 1,
      "title": "Workout Mix",
      "trackCount": 45,
      "lastUpdated": DateTime.now().subtract(const Duration(days: 2)),
      "artwork": "https://images.unsplash.com/photo-1649888254873-d9870ee286ee",
      "artworkDescription":
          "Energetic workout scene with dumbbells and water bottle on gym floor",
      "isDownloaded": true,
      "isCollaborative": false,
      "category": "Your Music",
    },
    {
      "id": 2,
      "title": "Chill Vibes",
      "trackCount": 32,
      "lastUpdated": DateTime.now().subtract(const Duration(days: 5)),
      "artwork": "https://images.unsplash.com/photo-1654508407597-a3fdebc28f47",
      "artworkDescription":
          "Peaceful sunset over calm ocean waters with warm orange and pink hues",
      "isDownloaded": false,
      "isCollaborative": true,
      "category": "Your Music",
    },
    {
      "id": 3,
      "title": "Road Trip Essentials",
      "trackCount": 67,
      "lastUpdated": DateTime.now().subtract(const Duration(days: 10)),
      "artwork": "https://images.unsplash.com/photo-1600590352787-b30aeb3f772a",
      "artworkDescription":
          "Open highway stretching into distance with mountains and blue sky",
      "isDownloaded": true,
      "isCollaborative": false,
      "category": "Your Music",
    },
    {
      "id": 4,
      "title": "Focus Flow",
      "trackCount": 28,
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 12)),
      "artwork":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1020c61d0-1765880035609.png",
      "artworkDescription":
          "Minimalist workspace with laptop, coffee cup, and notebook on wooden desk",
      "isDownloaded": false,
      "isCollaborative": false,
      "category": "Your Music",
    },
    {
      "id": 5,
      "title": "Discover Weekly",
      "trackCount": 30,
      "lastUpdated": DateTime.now().subtract(const Duration(days: 1)),
      "artwork": "https://images.unsplash.com/photo-1672742897777-7adeebaa430f",
      "artworkDescription":
          "Colorful vinyl records arranged in a fan pattern on turquoise background",
      "isDownloaded": false,
      "isCollaborative": false,
      "category": "Made for You",
    },
    {
      "id": 6,
      "title": "Daily Mix 1",
      "trackCount": 50,
      "lastUpdated": DateTime.now(),
      "artwork": "https://images.unsplash.com/photo-1559296277-83e29c0224e4",
      "artworkDescription":
          "Professional audio mixing console with colorful LED lights and faders",
      "isDownloaded": false,
      "isCollaborative": false,
      "category": "Made for You",
    },
    {
      "id": 7,
      "title": "Recently Played",
      "trackCount": 25,
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 3)),
      "artwork": "https://images.unsplash.com/photo-1721884258262-429b49dadb49",
      "artworkDescription":
          "Vintage headphones resting on vinyl record player with warm lighting",
      "isDownloaded": false,
      "isCollaborative": false,
      "category": "Recently Played",
    },
    {
      "id": 8,
      "title": "Offline Favorites",
      "trackCount": 89,
      "lastUpdated": DateTime.now().subtract(const Duration(days: 7)),
      "artwork": "https://images.unsplash.com/photo-1662671504604-c3c2493d74c6",
      "artworkDescription":
          "Smartphone with music app interface displaying colorful album artwork grid",
      "isDownloaded": true,
      "isCollaborative": false,
      "category": "Downloaded",
    },
  ];

  List<Map<String, dynamic>> get _filteredPlaylists {
    var playlists = _allPlaylists.where((playlist) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          (playlist['title'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesSegment = _selectedSegment == 0
          ? playlist['category'] == 'Your Music'
          : _selectedSegment == 1
          ? playlist['category'] == 'Made for You'
          : _selectedSegment == 2
          ? playlist['category'] == 'Recently Played'
          : playlist['isDownloaded'] == true;
      return matchesSearch && matchesSegment;
    }).toList();

    // Apply sorting
    switch (_sortOption) {
      case 'Alphabetical':
        playlists.sort(
          (a, b) => (a['title'] as String).compareTo(b['title'] as String),
        );
        break;
      case 'Most Played':
        playlists.sort(
          (a, b) => (b['trackCount'] as int).compareTo(a['trackCount'] as int),
        );
        break;
      case 'Recently Added':
      default:
        playlists.sort(
          (a, b) => (b['lastUpdated'] as DateTime).compareTo(
            a['lastUpdated'] as DateTime,
          ),
        );
        break;
    }

    return playlists;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar.home(
        onProfileTap: () =>
            Navigator.pushNamed(context, '/settings-and-profile'),
      ),
      body: Column(
        children: [
          LibraryHeaderWidget(
            searchQuery: _searchQuery,
            onSearchChanged: (query) => setState(() => _searchQuery = query),
            onSortPressed: _showSortOptions,
          ),
          SegmentControlWidget(
            selectedIndex: _selectedSegment,
            onSegmentChanged: (index) =>
                setState(() => _selectedSegment = index),
            segments: _segments,
          ),
          if (_selectedSegment == 3) ...[
            StorageInfoWidget(
              usedStorage: 3.2,
              totalStorage: 8.0,
              onManageStorage: _showManageStorageDialog,
            ),
          ],
          Expanded(child: _buildPlaylistList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePlaylistDialog,
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        label: const Text('Create Playlist'),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentRoute: '/library-and-playlists',
      ),
    );
  }

  Widget _buildPlaylistList() {
    final playlists = _filteredPlaylists;

    if (playlists.isEmpty) {
      return EmptyStateWidget(onCreatePlaylist: _showCreatePlaylistDialog);
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 10.h),
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return PlaylistCardWidget(
            playlist: playlist,
            onTap: () => _openPlaylist(playlist),
            onEdit: () => _editPlaylist(playlist),
            onDelete: () => _deletePlaylist(playlist),
            onShare: () => _sharePlaylist(playlist),
            onDownload: () => _downloadPlaylist(playlist),
          );
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Library synced successfully'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showSortOptions() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Text(
                'Sort By',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ..._sortOptions.map(
              (option) => RadioListTile<String>(
                title: Text(option, style: theme.textTheme.bodyLarge),
                value: option,
                groupValue: _sortOption,
                activeColor: colorScheme.primary,
                onChanged: (value) {
                  setState(() => _sortOption = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final nameController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Create New Playlist', style: theme.textTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Playlist Name',
                  hintText: 'Enter playlist name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                autofocus: true,
              ),
              SizedBox(height: 2.h),
              SwitchListTile(
                title: Text(
                  'Private Playlist',
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  'Only you can see this playlist',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                value: isPrivate,
                onChanged: (value) => setDialogState(() => isPrivate = value),
                activeThumbColor: colorScheme.primary,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Playlist "${nameController.text}" created successfully',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showManageStorageDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage Storage', style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Downloaded music is taking up 3.2 GB of storage.',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete_sweep',
                color: colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Clear All Downloads',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.error,
                ),
              ),
              subtitle: Text(
                'Remove all offline music',
                style: theme.textTheme.bodySmall,
              ),
              onTap: () {
                Navigator.pop(context);
                _showClearDownloadsConfirmation();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearDownloadsConfirmation() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Downloads?', style: theme.textTheme.titleLarge),
        content: Text(
          'This will remove all downloaded music from your device. You can re-download them anytime.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All downloads cleared successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _openPlaylist(Map<String, dynamic> playlist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening "${playlist['title']}"'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _editPlaylist(Map<String, dynamic> playlist) {
    final theme = Theme.of(context);
    final nameController = TextEditingController(text: playlist['title']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Playlist', style: theme.textTheme.titleLarge),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Playlist Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Playlist updated successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deletePlaylist(Map<String, dynamic> playlist) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Playlist?', style: theme.textTheme.titleLarge),
        content: Text(
          'Are you sure you want to delete "${playlist['title']}"? This action cannot be undone.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Playlist "${playlist['title']}" deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _sharePlaylist(Map<String, dynamic> playlist) {
    Share.share(
      'Check out my playlist "${playlist['title']}" on Crockstify! It has ${playlist['trackCount']} amazing songs.',
      subject: 'Share Playlist',
    );
  }

  void _downloadPlaylist(Map<String, dynamic> playlist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Downloading "${playlist['title']}" for offline listening...',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
