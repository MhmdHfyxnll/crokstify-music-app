import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Account section widget displaying subscription and payment information
///
/// Features:
/// - Subscription status display
/// - Subscription type and expiry
/// - Payment methods management
/// - Billing history access
/// - Secure payment integration
class AccountSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final VoidCallback onManageSubscription;
  final VoidCallback onPaymentMethods;
  final VoidCallback onBillingHistory;

  const AccountSectionWidget({
    super.key,
    required this.userProfile,
    required this.onManageSubscription,
    required this.onPaymentMethods,
    required this.onBillingHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            'Account',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
          ),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              // Subscription status card
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userProfile["subscriptionType"] as String,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Expires: ${_formatDate(userProfile["subscriptionExpiry"] as String)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.9,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onManageSubscription,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.onPrimary,
                          foregroundColor: theme.colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                        child: const Text('Manage Subscription'),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                thickness: 1,
                indent: 4.w,
                endIndent: 4.w,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),

              // Payment methods
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 0.5.h,
                ),
                leading: CustomIconWidget(
                  iconName: 'credit_card',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                title: Text(
                  'Payment Methods',
                  style: theme.textTheme.bodyLarge,
                ),
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                onTap: onPaymentMethods,
              ),

              Divider(
                height: 1,
                thickness: 1,
                indent: 4.w,
                endIndent: 4.w,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),

              // Billing history
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 0.5.h,
                ),
                leading: CustomIconWidget(
                  iconName: 'receipt_long',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                title: Text(
                  'Billing History',
                  style: theme.textTheme.bodyLarge,
                ),
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                onTap: onBillingHistory,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
