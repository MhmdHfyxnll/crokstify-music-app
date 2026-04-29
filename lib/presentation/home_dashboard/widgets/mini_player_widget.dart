import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayerWidget extends StatefulWidget {
  const MiniPlayerWidget({super.key});

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();

  int _currentIndex = 0;
  bool _isPlaying = false;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  final List<Map<String, String>> _playlist = [
    {
      "title": "Midnight Dreams",
      "artist": "Luna Eclipse",
      "url":
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    },
    {
      "title": "Neon Lights",
      "artist": "Cyber Wave",
      "url":
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    await _loadTrack();

    _player.positionStream.listen((pos) {
      if (mounted) {
        setState(() {
          _position = pos;
        });
      }
    });

    _player.durationStream.listen((dur) {
      if (dur != null && mounted) {
        setState(() {
          _duration = dur;
        });
      }
    });
  }

  Future<void> _loadTrack() async {
    await _player.setUrl(
      _playlist[_currentIndex]["url"]!,
    );
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }

    if (mounted) {
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  Future<void> _next() async {
    _currentIndex =
        (_currentIndex + 1) % _playlist.length;

    await _loadTrack();
    await _player.play();

    if (mounted) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future<void> _previous() async {
    _currentIndex =
        (_currentIndex - 1 + _playlist.length) %
            _playlist.length;

    await _loadTrack();
    await _player.play();

    if (mounted) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  String _formatTime(Duration d) {
    final minutes = d.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = d.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentSong = _playlist[_currentIndex];

    return Container(
      height: 13.h,
      margin: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 0.5.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 1.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: 0.08,
            ),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// ROW UTAMA
          Expanded(
            child: Row(
              children: [
                /// COVER
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child: Image.network(
                    "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200",
                    width: 14.w,
                    height: 14.w,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(width: 3.w),

                /// INFO LAGU
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong["title"]!,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontWeight:
                                  FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        currentSong["artist"]!,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: theme
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),

                /// CONTROLS
                IconButton(
                  onPressed: _previous,
                  icon: const Icon(
                    Icons.skip_previous,
                  ),
                ),

                IconButton(
                  onPressed: _playPause,
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 28,
                  ),
                ),

                IconButton(
                  onPressed: _next,
                  icon: const Icon(
                    Icons.skip_next,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 0.5.h),

          /// PROGRESS BAR DI BAWAH (SPOTIFY STYLE)
          Row(
            children: [
              Text(
                _formatTime(_position),
                style: theme.textTheme.bodySmall,
              ),

              SizedBox(width: 2.w),

              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context)
                      .copyWith(
                    trackHeight: 2,
                    thumbShape:
                        const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                    overlayShape:
                        const RoundSliderOverlayShape(
                      overlayRadius: 10,
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inSeconds == 0
                        ? 1
                        : _duration.inSeconds
                            .toDouble(),
                    value: _position.inSeconds
                        .clamp(
                          0,
                          _duration.inSeconds == 0
                              ? 1
                              : _duration
                                  .inSeconds,
                        )
                        .toDouble(),
                    onChanged: (value) {
                      _player.seek(
                        Duration(
                          seconds: value.toInt(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: 2.w),

              Text(
                _formatTime(_duration),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}