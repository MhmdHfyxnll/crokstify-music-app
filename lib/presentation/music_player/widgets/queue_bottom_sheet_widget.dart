import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Queue management bottom sheet widget
class QueueBottomSheetWidget extends StatefulWidget {
  final List<Map<String, dynamic>> queueItems;
  final int currentIndex;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(int index) onRemove;
  final VoidCallback onClose;

  const QueueBottomSheetWidget({
    super.key,
    required this.queueItems,
    required this.currentIndex,
    required this.onReorder,
    required this.onRemove,
    required this.onClose,
  });

  @override
  State<QueueBottomSheetWidget> createState() => _QueueBottomSheetWidgetState();
}

class _QueueBottomSheetWidgetState extends State<QueueBottomSheetWidget> {
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.queueItems);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Queue', style: theme.textTheme.titleLarge),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close_rounded',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),

          Divider(height: 1, color: theme.colorScheme.outline),

          // Queue list
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text(
                      'Queue is empty',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    itemCount: _items.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = _items.removeAt(oldIndex);
                        _items.insert(newIndex, item);
                      });
                      widget.onReorder(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final isCurrentlyPlaying = index == widget.currentIndex;

                      return Dismissible(
                        key: ValueKey(item['id']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 5.w),
                          color: theme.colorScheme.error,
                          child: CustomIconWidget(
                            iconName: 'delete_rounded',
                            color: theme.colorScheme.onError,
                            size: 24,
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() => _items.removeAt(index));
                          widget.onRemove(index);
                        },
                        child: Container(
                          color: isCurrentlyPlaying
                              ? theme.colorScheme.primaryContainer.withValues(
                                  alpha: 0.3,
                                )
                              : Colors.transparent,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CustomImageWidget(
                                imageUrl: item['albumArt'] as String,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                semanticLabel:
                                    item['albumArtSemanticLabel'] as String,
                              ),
                            ),
                            title: Text(
                              item['title'] as String,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: isCurrentlyPlaying
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isCurrentlyPlaying
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              item['artist'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: CustomIconWidget(
                              iconName: 'drag_handle_rounded',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
