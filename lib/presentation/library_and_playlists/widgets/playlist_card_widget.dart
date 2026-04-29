import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual playlist card with swipe actions
class PlaylistCardWidget extends StatelessWidget {
  final Map<String, dynamic> playlist;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onDownload;

  const PlaylistCardWidget({
    super.key,
    required this.playlist,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Slidable(
      key: ValueKey(playlist['id']),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            icon: Icons.edit_rounded,
            label: 'Edit',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                _buildPlaylistArtwork(context),
                SizedBox(width: 4.w),
                Expanded(child: _buildPlaylistInfo(context)),
                _buildPlaylistActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistArtwork(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: playlist['artwork'] != null
            ? CustomImageWidget(
                imageUrl: playlist['artwork'],
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
                semanticLabel:
                    playlist['artworkDescription'] ?? 'Playlist artwork',
              )
            : Center(
                child: CustomIconWidget(
                  iconName: 'music_note',
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
      ),
    );
  }

  Widget _buildPlaylistInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlist['title'] ?? 'Untitled Playlist',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            Text(
              '${playlist['trackCount'] ?? 0} songs',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (playlist['isDownloaded'] == true) ...[
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'download_done',
                color: colorScheme.primary,
                size: 14,
              ),
            ],
            if (playlist['isCollaborative'] == true) ...[
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'people',
                color: colorScheme.primary,
                size: 14,
              ),
            ],
          ],
        ),
        if (playlist['lastUpdated'] != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            'Updated ${_formatDate(playlist['lastUpdated'])}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildPlaylistActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomIconWidget(
      iconName: 'more_vert',
      color: colorScheme.onSurfaceVariant,
      size: 20,
    );
  }

  void _showContextMenu(BuildContext context) {
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
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: colorScheme.primary,
                size: 24,
              ),
              title: Text('Edit Details', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: colorScheme.primary,
                size: 24,
              ),
              title: Text('Share', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: colorScheme.primary,
                size: 24,
              ),
              title: Text('Duplicate', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _showDuplicateConfirmation(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: playlist['isDownloaded'] == true
                    ? 'download_done'
                    : 'download',
                color: colorScheme.primary,
                size: 24,
              ),
              title: Text(
                playlist['isDownloaded'] == true
                    ? 'Downloaded'
                    : 'Download for Offline',
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                if (playlist['isDownloaded'] != true) {
                  onDownload();
                }
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Delete Playlist',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showDuplicateConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Duplicate Playlist', style: theme.textTheme.titleLarge),
        content: Text(
          'Create a copy of "${playlist['title']}"?',
          style: theme.textTheme.bodyMedium,
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Playlist duplicated successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Duplicate'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }
}
