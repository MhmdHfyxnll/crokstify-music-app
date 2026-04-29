import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/album_artwork_widget.dart';
import './widgets/playback_controls_widget.dart';
import './widgets/progress_bar_widget.dart';
import './widgets/queue_bottom_sheet_widget.dart';
import './widgets/secondary_controls_widget.dart';
import './widgets/song_info_widget.dart';
import './widgets/volume_control_widget.dart';

/// Music Player screen providing full-screen playback control
class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer>
    with SingleTickerProviderStateMixin {
  // Mock data for current song
  final Map<String, dynamic> _currentSong = {
    "id": 1,
    "title": "Blinding Lights",
    "artist": "The Weeknd",
    "album": "After Hours",
    "albumArt": "https://images.unsplash.com/photo-1698679324756-63617972acb3",
    "albumArtSemanticLabel":
        "Neon-lit cityscape at night with vibrant purple and blue lights reflecting on wet streets",
    "duration": Duration(minutes: 3, seconds: 20),
  };

  // Mock queue data
  final List<Map<String, dynamic>> _queueItems = [
    {
      "id": 1,
      "title": "Blinding Lights",
      "artist": "The Weeknd",
      "albumArt":
          "https://images.unsplash.com/photo-1698679324756-63617972acb3",
      "albumArtSemanticLabel":
          "Neon-lit cityscape at night with vibrant purple and blue lights reflecting on wet streets",
    },
    {
      "id": 2,
      "title": "Save Your Tears",
      "artist": "The Weeknd",
      "albumArt":
          "https://images.unsplash.com/photo-1584521947172-ad6d0433b172",
      "albumArtSemanticLabel":
          "Concert stage with dramatic red and blue lighting and silhouettes of crowd",
    },
    {
      "id": 3,
      "title": "Starboy",
      "artist": "The Weeknd ft. Daft Punk",
      "albumArt":
          "https://images.unsplash.com/photo-1587656789042-629c8a609b58",
      "albumArtSemanticLabel":
          "Vintage audio equipment with warm orange lighting and vinyl records",
    },
    {
      "id": 4,
      "title": "Can't Feel My Face",
      "artist": "The Weeknd",
      "albumArt":
          "https://images.unsplash.com/photo-1585848061832-19e2fd237f8f",
      "albumArtSemanticLabel":
          "Music studio with professional recording equipment and purple ambient lighting",
    },
  ];

  // Playback state
  bool _isPlaying = true;
  Duration _currentPosition = const Duration(minutes: 1, seconds: 30);
  bool _isFavorite = false;
  bool _isShuffleEnabled = false;
  String _repeatMode = 'off'; // 'off', 'all', 'one'
  double _volume = 0.7;
  int _currentQueueIndex = 0;

  // Animation controller for parallax effect
  late AnimationController _parallaxController;
  late Animation<double> _parallaxAnimation;

  @override
  void initState() {
    super.initState();
    _parallaxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _parallaxAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _parallaxController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _parallaxController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
  }

  void _onPrevious() {
    _parallaxController.forward(from: 0.0);
    setState(() {
      _currentPosition = Duration.zero;
      if (_currentQueueIndex > 0) {
        _currentQueueIndex--;
      }
    });
  }

  void _onNext() {
    _parallaxController.forward(from: 0.0);
    setState(() {
      _currentPosition = Duration.zero;
      if (_currentQueueIndex < _queueItems.length - 1) {
        _currentQueueIndex++;
      }
    });
  }

  void _onSeek(Duration position) {
    setState(() => _currentPosition = position);
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  void _onShare() {
    // Share functionality would integrate with native share sheet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${_currentSong['title']}"...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleShuffle() {
    setState(() => _isShuffleEnabled = !_isShuffleEnabled);
  }

  void _toggleRepeat() {
    setState(() {
      _repeatMode = _repeatMode == 'off'
          ? 'all'
          : _repeatMode == 'all'
          ? 'one'
          : 'off';
    });
  }

  void _showQueue() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QueueBottomSheetWidget(
        queueItems: _queueItems,
        currentIndex: _currentQueueIndex,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _queueItems.removeAt(oldIndex);
            _queueItems.insert(newIndex, item);
          });
        },
        onRemove: (index) {
          setState(() => _queueItems.removeAt(index));
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showOptionsMenu() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'playlist_add_rounded',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text(
                  'Add to Playlist',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/library-and-playlists');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'album_rounded',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text('Go to Album', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home-dashboard');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'person_rounded',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text('Go to Artist', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/search-and-discovery');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'bedtime_rounded',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text('Sleep Timer', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _showSleepTimerDialog();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'tune_rounded',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text(
                  'Crossfade Settings',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings-and-profile');
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showSleepTimerDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sleep Timer', style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('15 minutes'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('30 minutes'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('45 minutes'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('1 hour'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar.player(transparent: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // Album artwork with parallax effect
              AnimatedBuilder(
                animation: _parallaxAnimation,
                builder: (context, child) {
                  return AlbumArtworkWidget(
                    imageUrl: _currentSong['albumArt'] as String,
                    semanticLabel:
                        _currentSong['albumArtSemanticLabel'] as String,
                    parallaxOffset: _parallaxAnimation.value,
                  );
                },
              ),

              SizedBox(height: 2.h),

              // Song information
              SongInfoWidget(
                songTitle: _currentSong['title'] as String,
                artistName: _currentSong['artist'] as String,
                albumName: _currentSong['album'] as String,
                isFavorite: _isFavorite,
                onFavoriteToggle: _toggleFavorite,
                onShare: _onShare,
              ),

              SizedBox(height: 2.h),

              // Progress bar
              ProgressBarWidget(
                currentPosition: _currentPosition,
                totalDuration: _currentSong['duration'] as Duration,
                onSeek: _onSeek,
              ),

              SizedBox(height: 3.h),

              // Primary playback controls
              PlaybackControlsWidget(
                isPlaying: _isPlaying,
                onPlayPause: _togglePlayPause,
                onPrevious: _onPrevious,
                onNext: _onNext,
              ),

              SizedBox(height: 2.h),

              // Secondary controls
              SecondaryControlsWidget(
                isShuffleEnabled: _isShuffleEnabled,
                repeatMode: _repeatMode,
                onShuffleToggle: _toggleShuffle,
                onRepeatToggle: _toggleRepeat,
                onQueueTap: _showQueue,
                onOptionsTap: _showOptionsMenu,
              ),

              SizedBox(height: 2.h),

              // Volume control
              VolumeControlWidget(
                volume: _volume,
                onVolumeChanged: (value) => setState(() => _volume = value),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
