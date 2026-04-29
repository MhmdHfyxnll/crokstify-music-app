import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/user_session.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/account_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import '../login/login_screen.dart';

class SettingsAndProfile extends StatefulWidget {
  const SettingsAndProfile({super.key});

  @override
  State<SettingsAndProfile> createState() => _SettingsAndProfileState();
}

class _SettingsAndProfileState extends State<SettingsAndProfile> {
  /// =============================
  /// USER DATA FROM LOGIN
  /// =============================
  String userName = "Guest";
  String userEmail = "guest@email.com";

  Map<String, dynamic> _userProfile = {
    "username": "Guest",
    "email": "guest@email.com",
    "avatar":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1e13bc62a-1763294059113.png",
    "semanticLabel": "Profile avatar",
    "followers": 1234,
    "following": 567,
    "isPremium": true,
    "subscriptionType": "Premium Family",
    "subscriptionExpiry": "2026-12-31",
  };

  /// =============================
  /// AUDIO SETTINGS
  /// =============================
  String _streamingQuality = "High";
  String _downloadQuality = "Very High";

  double _crossfadeDuration = 5.0;
  bool _gaplessPlayback = true;
  bool _volumeNormalization = true;
  String _equalizerPreset = "Flat";

  bool _playlistPrivacy = false;
  bool _activitySharing = true;
  bool _friendDiscovery = true;

  bool _newReleaseAlerts = true;
  bool _playlistUpdates = true;
  bool _socialActivity = false;

  final String _cacheSize = "2.4 GB";
  final String _downloadedStorage = "8.7 GB";

  bool _listeningHistory = true;
  bool _dataCollection = false;
  String _accountVisibility = "Friends Only";

  bool _largerText = false;
  bool _reducedMotion = false;
  bool _voiceControl = false;

  bool _biometricAuth = true;
  bool _biometricPurchases = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// =============================
  /// LOAD USER DATA
  /// =============================
  Future<void> _loadUserData() async {
    final user = await UserSession.getUser();

    if (mounted) {
      setState(() {
        userName = user['name'] ?? 'Guest';
        userEmail = user['email'] ?? 'guest@email.com';

        _userProfile["username"] = userName;
        _userProfile["email"] = userEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.secondary(
        title: 'Settings & Profile',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /// PROFILE HEADER
              ProfileHeaderWidget(
                userProfile: _userProfile,
                onEditProfile: _handleEditProfile,
              ),

              SizedBox(height: 2.h),

              /// AUDIO QUALITY
              SettingsSectionWidget(
                title: 'Audio Quality',
                children: [
                  _buildDropdownTile(
                    context,
                    'Streaming Quality',
                    _streamingQuality,
                    ['Low', 'Normal', 'High', 'Very High'],
                    (value) {
                      setState(() {
                        _streamingQuality = value ?? 'High';
                      });
                    },
                    subtitle: _getDataUsageEstimate(_streamingQuality),
                  ),
                  _buildDropdownTile(
                    context,
                    'Download Quality',
                    _downloadQuality,
                    ['Normal', 'High', 'Very High'],
                    (value) {
                      setState(() {
                        _downloadQuality = value ?? 'Very High';
                      });
                    },
                    subtitle: _getDataUsageEstimate(_downloadQuality),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              /// PLAYBACK
              SettingsSectionWidget(
                title: 'Playback',
                children: [
                  _buildSwitchTile(
                    context,
                    'Gapless Playback',
                    _gaplessPlayback,
                    (value) {
                      setState(() {
                        _gaplessPlayback = value;
                      });
                    },
                  ),
                  _buildSwitchTile(
                    context,
                    'Volume Normalization',
                    _volumeNormalization,
                    (value) {
                      setState(() {
                        _volumeNormalization = value;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              /// ACCOUNT SECTION
              AccountSectionWidget(
                userProfile: _userProfile,
                onManageSubscription: _handleManageSubscription,
                onPaymentMethods: _handlePaymentMethods,
                onBillingHistory: _handleBillingHistory,
              ),

              SizedBox(height: 2.h),

              /// LOGOUT BUTTON
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _handleLogout,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.6.h),
                      side: BorderSide(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  /// =============================
  /// REUSABLE WIDGETS
  /// =============================

  Widget _buildDropdownTile(
    BuildContext context,
    String title,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged, {
    String? subtitle,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 0.5.h,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall,
            )
          : null,
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 0.5.h,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  String _getDataUsageEstimate(String quality) {
    switch (quality) {
      case 'Low':
        return '~24 MB/hour';
      case 'Normal':
        return '~40 MB/hour';
      case 'High':
        return '~96 MB/hour';
      case 'Very High':
        return '~144 MB/hour';
      default:
        return '';
    }
  }

  /// =============================
  /// ACTIONS
  /// =============================

  void _handleEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit Profile clicked'),
      ),
    );
  }

  void _handleManageSubscription() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Manage Subscription clicked'),
      ),
    );
  }

  void _handlePaymentMethods() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Methods clicked'),
      ),
    );
  }

  void _handleBillingHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Billing History clicked'),
      ),
    );
  }

  Future<void> _handleLogout() async {
    await UserSession.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
}