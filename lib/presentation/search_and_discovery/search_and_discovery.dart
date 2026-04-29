import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_categories_widget.dart';
import './widgets/search_results_widget.dart';
import './widgets/trending_searches_widget.dart';

/// Search and Discovery screen for comprehensive music exploration
/// Implements multiple input methods: text search, voice search, and barcode scanning
/// Features real-time suggestions, categorized results, and trending content
class SearchAndDiscovery extends StatefulWidget {
  const SearchAndDiscovery({super.key});

  @override
  State<SearchAndDiscovery> createState() => _SearchAndDiscoveryState();
}

class _SearchAndDiscoveryState extends State<SearchAndDiscovery>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  bool _isSearching = false;
  String _selectedCategory = 'All';

  // Search categories for tab navigation
  final List<String> _categories = [
    'All',
    'Songs',
    'Artists',
    'Albums',
    'Playlists',
    'Podcasts',
  ];

  // Mock recent searches data
  final List<String> _recentSearches = [
    'Bohemian Rhapsody',
    'Taylor Swift',
    'Thriller Album',
    'Chill Vibes Playlist',
    'The Joe Rogan Experience',
  ];

  // Mock trending searches data
  final List<Map<String, dynamic>> _trendingSearches = [
    {
      "query": "Blinding Lights",
      "artist": "The Weeknd",
      "trend": "up",
      "searches": "2.5M",
    },
    {
      "query": "Bad Bunny",
      "artist": "Artist",
      "trend": "up",
      "searches": "1.8M",
    },
    {
      "query": "Anti-Hero",
      "artist": "Taylor Swift",
      "trend": "stable",
      "searches": "1.2M",
    },
    {
      "query": "Spotify Wrapped 2025",
      "artist": "Playlist",
      "trend": "up",
      "searches": "950K",
    },
    {
      "query": "Calm Piano",
      "artist": "Playlist",
      "trend": "down",
      "searches": "780K",
    },
  ];

  // Mock search results data
  final Map<String, List<Map<String, dynamic>>> _searchResults = {
    'Songs': [
      {
        "id": 1,
        "title": "Blinding Lights",
        "artist": "The Weeknd",
        "album": "After Hours",
        "duration": "3:20",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_15fed007f-1764683891397.png",
        "semanticLabel":
            "Album cover showing neon lights and dark cityscape at night",
      },
      {
        "id": 2,
        "title": "Anti-Hero",
        "artist": "Taylor Swift",
        "album": "Midnights",
        "duration": "3:21",
        "image": "https://images.unsplash.com/photo-1620164654914-cfa3cef2e26e",
        "semanticLabel":
            "Microphone on stage with purple and blue concert lighting",
      },
      {
        "id": 3,
        "title": "As It Was",
        "artist": "Harry Styles",
        "album": "Harry's House",
        "duration": "2:47",
        "image": "https://images.unsplash.com/photo-1431069767777-c37892aa0a07",
        "semanticLabel": "Acoustic guitar leaning against vintage amplifier",
      },
    ],
    'Artists': [
      {
        "id": 1,
        "name": "The Weeknd",
        "followers": "95.2M",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_12947af48-1763294452994.png",
        "semanticLabel":
            "Portrait of man with short dark hair wearing black leather jacket",
      },
      {
        "id": 2,
        "name": "Taylor Swift",
        "followers": "89.5M",
        "image": "https://images.unsplash.com/photo-1542131596-dea5384842c7",
        "semanticLabel":
            "Portrait of woman with long blonde hair and red lipstick",
      },
      {
        "id": 3,
        "name": "Bad Bunny",
        "followers": "78.3M",
        "image": "https://images.unsplash.com/photo-1615596348777-030164187f78",
        "semanticLabel":
            "Portrait of man with sunglasses and casual streetwear",
      },
    ],
    'Albums': [
      {
        "id": 1,
        "title": "After Hours",
        "artist": "The Weeknd",
        "year": "2020",
        "tracks": "14 songs",
        "image": "https://images.unsplash.com/photo-1549400603-74346c10947f",
        "semanticLabel": "Red and black abstract album artwork with neon glow",
      },
      {
        "id": 2,
        "title": "Midnights",
        "artist": "Taylor Swift",
        "year": "2022",
        "tracks": "13 songs",
        "image": "https://images.unsplash.com/photo-1548032567-7754bcfdea7f",
        "semanticLabel": "Dark blue midnight sky with stars and moon",
      },
    ],
    'Playlists': [
      {
        "id": 1,
        "title": "Today's Top Hits",
        "creator": "Spotify",
        "tracks": "50 songs",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_13bbf2b2e-1764668834969.png",
        "semanticLabel": "Colorful music equalizer bars on dark background",
      },
      {
        "id": 2,
        "title": "Chill Vibes",
        "creator": "Spotify",
        "tracks": "100 songs",
        "image": "https://images.unsplash.com/photo-1594605811198-d44b80dcc718",
        "semanticLabel": "Peaceful sunset over calm ocean waters",
      },
    ],
    'Podcasts': [
      {
        "id": 1,
        "title": "The Joe Rogan Experience",
        "host": "Joe Rogan",
        "episodes": "2000+ episodes",
        "image": "https://images.unsplash.com/photo-1585923329480-e2f1f8e569c1",
        "semanticLabel":
            "Professional podcast microphone setup with headphones",
      },
      {
        "id": 2,
        "title": "Crime Junkie",
        "host": "Ashley Flowers",
        "episodes": "350+ episodes",
        "image":
            "https://img.rocket.new/generatedImages/rocket_gen_img_16689735e-1766330812967.png",
        "semanticLabel": "Vintage detective magnifying glass on old documents",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _searchFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.removeListener(_handleFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
      });
    }
  }

  void _handleFocusChange() {
    setState(() {});
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });
  }

  void _handleVoiceSearch() {
    // Voice search implementation would go here
    // For now, show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleBarcodeScanner() {
    // Barcode scanner implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Barcode scanner feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleRecentSearchTap(String query) {
    _searchController.text = query;
    _handleSearch(query);
  }

  void _handleRecentSearchRemove(String query) {
    setState(() {
      _recentSearches.remove(query);
    });
  }

  void _handleTrendingSearchTap(String query) {
    _searchController.text = query;
    _handleSearch(query);
  }

  void _clearSearch() {
    _searchController.clear();
    _handleSearch('');
    _searchFocusNode.unfocus();
  }

  List<Map<String, dynamic>> _getFilteredResults() {
    if (_searchQuery.isEmpty) return [];

    if (_selectedCategory == 'All') {
      // Combine results from all categories
      List<Map<String, dynamic>> allResults = [];
      _searchResults.forEach((category, results) {
        allResults.addAll(
          results.map((item) => {...item, 'category': category}),
        );
      });
      return allResults;
    }

    return _searchResults[_selectedCategory] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.search(
        searchQuery: _searchQuery,
        onSearchChanged: _handleSearch,
        onProfileTap: () {
          Navigator.pushNamed(context, '/settings-and-profile');
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar with voice and barcode scanner
            SearchBarWidget(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _handleSearch,
              onVoiceSearch: _handleVoiceSearch,
              onBarcodeScanner: _handleBarcodeScanner,
              onClear: _clearSearch,
            ),

            // Search categories tabs
            _isSearching
                ? SearchCategoriesWidget(
                    categories: _categories,
                    tabController: _tabController,
                  )
                : SizedBox.shrink(),

            // Main content area
            Expanded(
              child: _isSearching
                  ? SearchResultsWidget(
                      results: _getFilteredResults(),
                      selectedCategory: _selectedCategory,
                      searchQuery: _searchQuery,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recent searches
                          _recentSearches.isNotEmpty
                              ? RecentSearchesWidget(
                                  searches: _recentSearches,
                                  onSearchTap: _handleRecentSearchTap,
                                  onSearchRemove: _handleRecentSearchRemove,
                                )
                              : SizedBox.shrink(),

                          SizedBox(height: 2.h),

                          // Trending searches
                          TrendingSearchesWidget(
                            trendingSearches: _trendingSearches,
                            onSearchTap: _handleTrendingSearchTap,
                          ),

                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentRoute: '/search-and-discovery',
        onNavigate: (route) {
          if (route != '/search-and-discovery') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}

