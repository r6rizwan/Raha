import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/l10n.dart';
import '../services/api_service.dart';

class AppVersionMetadata {
  final String minAppVersion;
  final String latestAppVersion;
  final String updateUrl;

  AppVersionMetadata({
    required this.minAppVersion,
    required this.latestAppVersion,
    required this.updateUrl,
  });

  factory AppVersionMetadata.fromJson(Map<String, dynamic> json) {
    return AppVersionMetadata(
      minAppVersion: json['minAppVersion'] ?? '1.0.0',
      latestAppVersion: json['latestAppVersion'] ?? '1.0.0',
      updateUrl: json['updateUrl'] ?? 'https://github.com/r6rizwan/Raha/releases',
    );
  }
}

final updateCheckerProvider = Provider<UpdateCheckerService>((ref) {
  return UpdateCheckerService(ref.read(apiServiceProvider));
});

class UpdateCheckerService {
  final ApiService _api;
  UpdateCheckerService(this._api);

  Future<AppVersionMetadata?> checkVersion() async {
    try {
      final response = await _api.dio.get('/health');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return AppVersionMetadata.fromJson(response.data['data']);
      }
    } catch (_) {
      // Fail silently if health endpoint fails
    }
    return null;
  }
}

/// Helper method to compare two semantic version strings (e.g. "1.0.1" and "1.0.0").
/// Returns positive if v1 > v2, negative if v1 < v2, and 0 if v1 == v2.
int compareVersion(String v1, String v2) {
  final cleanV1 = v1.split('+')[0].split('-')[0];
  final cleanV2 = v2.split('+')[0].split('-')[0];
  final v1Parts = cleanV1.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  final v2Parts = cleanV2.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  for (var i = 0; i < 3; i++) {
    final part1 = i < v1Parts.length ? v1Parts[i] : 0;
    final part2 = i < v2Parts.length ? v2Parts[i] : 0;
    if (part1 != part2) {
      return part1.compareTo(part2);
    }
  }
  return 0;
}

Future<void> performVersionCheck(
  BuildContext context,
  WidgetRef ref, {
  bool showUpToDateFeedback = false,
}) async {
  final checkService = ref.read(updateCheckerProvider);
  final meta = await checkService.checkVersion();
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;
  if (meta == null || !context.mounted) return;
  final l10n = context.l10n;

  final needsForceUpdate = compareVersion(meta.minAppVersion, currentVersion) > 0;
  final hasNewUpdate = compareVersion(meta.latestAppVersion, currentVersion) > 0;

  if (needsForceUpdate) {
    // Show non-dismissible dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            l10n.updateRequired,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            l10n.updateRequiredMessage,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(meta.updateUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                l10n.updateNow,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A5D4B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } else if (hasNewUpdate) {
    // Show optional update dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.newUpdateAvailable,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          l10n.newUpdateAvailableMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.later, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final uri = Uri.parse(meta.updateUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(
              l10n.updateNow,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A5D4B),
              ),
            ),
          ),
        ],
      ),
    );
  } else if (showUpToDateFeedback && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.appUpToDate)));
  }
}
