import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/l10n.dart';

class AppVersionMetadata {
  final String latestAppVersion;
  final String updateUrl;

  AppVersionMetadata({required this.latestAppVersion, required this.updateUrl});

  factory AppVersionMetadata.fromJson(Map<String, dynamic> json) {
    return AppVersionMetadata(
      latestAppVersion: json['tag_name'] ?? json['name'] ?? '1.0.0',
      updateUrl:
          json['html_url'] ?? 'https://github.com/r6rizwan/Raha/releases',
    );
  }
}

final updateCheckerProvider = Provider<UpdateCheckerService>((ref) {
  return UpdateCheckerService();
});

class UpdateCheckerService {
  static const _latestReleaseUrl =
      'https://api.github.com/repos/r6rizwan/Raha/releases/latest';

  Future<AppVersionMetadata?> checkVersion() async {
    try {
      final response = await Dio().get(
        _latestReleaseUrl,
        options: Options(
          headers: const {
            'Accept': 'application/vnd.github+json',
            'X-GitHub-Api-Version': '2022-11-28',
          },
        ),
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return AppVersionMetadata.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
    } catch (_) {
      // Fail silently if release lookup fails
    }
    return null;
  }
}

/// Helper method to compare two semantic version strings (e.g. "1.0.1" and "1.0.0").
/// Returns positive if v1 > v2, negative if v1 < v2, and 0 if v1 == v2.
int compareVersion(String v1, String v2) {
  List<int> parseParts(String raw) {
    final clean = raw.trim().split('+')[0].split('-')[0].toLowerCase();
    final normalized = clean.startsWith('v') ? clean.substring(1) : clean;
    return normalized
        .split('.')
        .map((s) => int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
  }

  final v1Parts = parseParts(v1);
  final v2Parts = parseParts(v2);
  final length = v1Parts.length > v2Parts.length
      ? v1Parts.length
      : v2Parts.length;

  for (var i = 0; i < length; i++) {
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

  final hasNewUpdate =
      compareVersion(meta.latestAppVersion, currentVersion) > 0;

  if (hasNewUpdate) {
    // Show optional update dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.newUpdateAvailable,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(l10n.newUpdateAvailableMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.later, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final uri = Uri.parse(meta.updateUrl);
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              if (context.mounted) Navigator.pop(context);
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
