import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final cacheServiceProvider = Provider<CacheService>((ref) => CacheService());

class CacheService {
  final _storage = const FlutterSecureStorage();

  Future<void> writeJson(String key, Object value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  Future<T?> readJson<T>(String key, T Function(Object? json) fromJson) async {
    final raw = await _storage.read(key: key);
    if (raw == null) return null;
    return fromJson(jsonDecode(raw));
  }
}
