import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
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

  void _initPlayer() async {
    await _loadTrack();

    _player.positionStream.listen((pos) {
      setState(() => _position = pos);
    });

    _player.durationStream.listen((dur) {
      if (dur != null) setState(() => _duration = dur);
    });
  }

  Future<void> _loadTrack() async {
    await _player.setUrl(_playlist[_currentIndex]["url"]!);
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  Future<void> _next() async {
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await _loadTrack();
    await _player.play();
    setState(() => _isPlaying = true);
  }

  Future<void> _previous() async {
    _currentIndex =
        (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await _loadTrack();
    await _player.play();
    setState(() => _isPlaying = true);
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = _playlist[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// 🎵 COVER
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=500",
                width: 280,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// 🎧 TITLE
          Text(
            song["title"]!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            song["artist"]!,
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 30),

          /// 🎵 SLIDER
          Slider(
            activeColor: Colors.green,
            inactiveColor: Colors.white30,
            min: 0,
            max: _duration.inSeconds.toDouble() == 0
                ? 1
                : _duration.inSeconds.toDouble(),
            value: _position.inSeconds
                .clamp(0, _duration.inSeconds)
                .toDouble(),
            onChanged: (value) {
              _player.seek(Duration(seconds: value.toInt()));
            },
          ),

          /// ⏱️ TIME
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatTime(_position),
                    style: const TextStyle(color: Colors.white70)),
                Text(_formatTime(_duration),
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 🎛️ CONTROLS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle, color: Colors.white70),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous,
                    color: Colors.white, size: 40),
                onPressed: _previous,
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white,
                  size: 70,
                ),
                onPressed: _playPause,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next,
                    color: Colors.white, size: 40),
                onPressed: _next,
              ),
              IconButton(
                icon: const Icon(Icons.repeat, color: Colors.white70),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ❤️ FAVORITE
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}