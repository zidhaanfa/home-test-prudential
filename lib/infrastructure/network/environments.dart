import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../platform/storage/get_storage_impl.dart';

// ─── Environment Enum ────────────────────────────────────────

/// Enum untuk tipe environment yang tersedia.
enum Environment {
  dev('dev', Colors.purple),
  staging('staging', Colors.orange),
  prod('prod', Colors.transparent);

  final String label;
  final Color badgeColor;

  const Environment(this.label, this.badgeColor);

  bool get isProduction => this == Environment.prod;
}

// ─── Environment Config (typed) ──────────────────────────────

/// Typed class untuk semua konfigurasi per-environment.
/// Menggantikan Map&lt;String, String&gt; agar compile-time safe.
class EnvironmentConfig {
  final Environment env;
  final String api;

  const EnvironmentConfig({required this.env, required this.api});
}

// ─── Environment Controller ─────────────────────────────────

/// Controller untuk mengelola environment aktif secara reaktif.
class EnvironmentController extends GetxController {
  final Rx<Environment> currentEnv = Environment.dev.obs;

  @override
  void onInit() {
    super.onInit();
    _initEnvFromStorage();
  }

  void _initEnvFromStorage() {
    final storage = GetStorageImpl();
    final storedEnvStr = storage.read<String>(StorageValue.env);

    if (storedEnvStr == null || storedEnvStr.isEmpty) {
      // Jika kosong, write ke storage berdasarkan currentEnv saat ini.
      storage.write(StorageValue.env, currentEnv.value.label);
    } else {
      // Jika ada isi, update currentEnv berdasarkan nilai di storage.
      final savedEnv = Environment.values.firstWhere(
        (e) => e.label == storedEnvStr,
        orElse: () => Environment.dev, // Fallback jika string tidak cocok
      );
      currentEnv.value = savedEnv;
    }
  }

  /// Switch environment secara runtime dan simpan state barunya ke storage.
  void switchEnvironment(Environment env) {
    currentEnv.value = env;
    GetStorageImpl().write(StorageValue.env, env.label);
  }
}

// ─── Config Environments ────────────────────────────────────

/// Menyediakan konfigurasi environment berdasarkan environment aktif.
///
/// Semua value dibaca dari `.env` file dan di-cast ke [EnvironmentConfig].
class ConfigEnvironments {
  static final EnvironmentController _controller = Get.put(
    EnvironmentController(),
  );

  /// Environment yang sedang aktif.
  static Environment get current => _controller.currentEnv.value;

  /// Mendapatkan konfigurasi untuk environment aktif.
  static EnvironmentConfig get config {
    return _configs.firstWhere((c) => c.env == current);
  }

  static final List<EnvironmentConfig> _configs = [
    EnvironmentConfig(env: Environment.dev, api: dotenv.env['API'] ?? 'API'),
  ];
}
