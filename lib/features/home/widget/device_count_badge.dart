import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hiddify/features/connection/model/connection_status.dart';
import 'package:hiddify/features/connection/notifier/connection_notifier.dart';
import 'package:hiddify/features/home/data/device_count_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Shows connected device count for the active subscription.
/// - Auto-refreshes every 60 s (via invalidateSelf in the provider).
/// - Force-refreshes when VPN connects.
/// - Has a manual refresh button.
class DeviceCountBadge extends ConsumerWidget {
  const DeviceCountBadge({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = extractDeviceUsername(url);
    if (token == null) return const SizedBox.shrink();

    // Force-refresh when VPN connects — with delay so server registers the connection
    ref.listen(connectionNotifierProvider, (previous, next) {
      final wasConnected = previous?.valueOrNull is Connected;
      final isConnected = next.valueOrNull is Connected;
      if (!wasConnected && isConnected) {
        // 3 s delay: give the server time to register the new device
        Timer(const Duration(seconds: 3), () => ref.invalidate(deviceCountProvider(token)));
        // Second refresh at 8 s in case 3 s wasn't enough
        Timer(const Duration(seconds: 8), () => ref.invalidate(deviceCountProvider(token)));
      }
    });

    final asyncInfo = ref.watch(deviceCountProvider(token));
    final isLoading = asyncInfo.isLoading;

    void refresh() => ref.invalidate(deviceCountProvider(token));

    return asyncInfo.when(
      skipLoadingOnRefresh: true,
      skipError: true, // on refresh error keep showing last known data instead of hiding
      data: (info) {
        if (info == null) return const SizedBox.shrink();
        final limitStr = info.limit == 0 ? '∞' : '${info.limit}';
        return _DeviceBadge(
          text: '📱 ${info.connected} / $limitStr',
          isLoading: isLoading,
          onRefresh: refresh,
        );
      },
      loading: () => _DeviceBadge(
        text: '📱 — / —',
        isLoading: true,
        onRefresh: refresh,
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _DeviceBadge extends StatelessWidget {
  const _DeviceBadge({
    required this.text,
    required this.isLoading,
    required this.onRefresh,
  });

  final String text;
  final bool isLoading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(color: color),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 20,
          height: 20,
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(3),
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: color,
                  ),
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 14,
                  icon: Icon(Icons.refresh_rounded, color: color),
                  tooltip: 'Обновить',
                  onPressed: onRefresh,
                ),
        ),
      ],
    );
  }
}
