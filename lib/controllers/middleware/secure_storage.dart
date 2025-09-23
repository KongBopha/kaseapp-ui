
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AndroidOptions _android() => const AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: true,
      );

  Future<String> readData({required String key}) async {
    if (!kIsWeb && Platform.isAndroid) {
      return await _storage.read(
            aOptions: _android(),
            key: key,
          ) ??
          '';
    }
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  Future<void> writeData({
    required String key,
    required String value,
  }) async {
    if (!kIsWeb && Platform.isAndroid) {
      await _storage.write(
        aOptions: _android(),
        key: key,
        value: value,
      );
    } else {
      final SharedPreferences prefs = await _prefs;
      prefs.setString(key, value);
    }
  }

  Future<void> delete({required String key}) async {
    if (!kIsWeb && Platform.isAndroid) {
      await _storage.delete(aOptions: _android(), key: key);
    } else {
      final SharedPreferences prefs = await _prefs;
      prefs.remove(key);
    }
  }

  Future<String> getAccessToken() async => await readData(key: 'token');
  Future<String> getRefreshToken() async => await readData(key: 'refresh_token');

  Future<void> saveTokens(String access, String refresh) async {
    await writeData(key: 'token', value: access);
    await writeData(key: 'refresh_token', value: refresh);
  }

  Future<void> clearTokens() async {
    await delete(key: 'token');
    await delete(key: 'refresh_token');
  }
}
