import 'package:flutter/material.dart';

import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/library_and_playlists/library_and_playlists.dart';
import '../presentation/search_and_discovery/search_and_discovery.dart';
import '../presentation/settings_and_profile/settings_and_profile.dart';

// 🔥 FIX IMPORT (INI YANG BENAR)
import '../presentation/music_player/music_player_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String libraryAndPlaylists = '/library-and-playlists';
  static const String searchAndDiscovery = '/search-and-discovery';
  static const String settingsAndProfile = '/settings-and-profile';
  static const String musicPlayer = '/music-player';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    libraryAndPlaylists: (context) => const LibraryAndPlaylists(),
    searchAndDiscovery: (context) => const SearchAndDiscovery(),
    settingsAndProfile: (context) => const SettingsAndProfile(),

    // 🔥 FIX ROUTE
    musicPlayer: (context) => const MusicPlayerScreen(),
  };
}