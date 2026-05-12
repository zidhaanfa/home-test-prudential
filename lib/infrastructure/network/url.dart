import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'environments.dart';

// ─── Path Segments ──────────────────────────────────────────

/// Konstanta path segment, menghindari typo pada string path.
// class PathSegment {
//   static const String banner = '/assets/banner/';
//   static const String v1 = '/v1';
//   static const String v2 = '/v2';
//   static const String api = '/api';
//   static const String nexbill = '/nexbill';
//   static const String nexads = '/nexads';
//   static const String public = '/public';
// }

// ─── App Cast URLs ──────────────────────────────────────────

/// AppCast URLs (tidak tergantung environment).
class AppCastUrl {
  static String get android => dotenv.env['URL_APPCAST_ANDROID']!;
  static String get ios => dotenv.env['URL_APPCAST_IOS']!;
}

// ─── Domain Builder ─────────────────────────────────────────

/// Membangun base URL dari [EnvironmentConfig] + path segments.
///
/// Akses langsung via typed property, tidak ada string key.
/// Contoh: `Domain.sso` → `https://sso.dev.example.com/api/v1`
class Domain {
  static EnvironmentConfig get _cfg => ConfigEnvironments.config;

  // ── Backend Services (API v1) ──
  static String get api => _cfg.api;
}

// ─── URL Endpoints ──────────────────────────────────────────

/// Semua endpoint API yang digunakan di seluruh aplikasi.
///
/// Tambahkan endpoint baru di sini untuk menghindari
/// string endpoint tersebar di banyak file.
///
/// ```dart
/// final url = Endpoint.sso.login; // "https://sso.../auth/login"
/// ```
class Endpoint {
  Endpoint._();

  // ── Auth ──
  static final auth = _AuthEndpoints();

  // ── Product ──
  static final products = _ProductEndpoints();
}

class _AuthEndpoints {
  String get login => '${Domain.api}/auth/login';
  String get refresh => '${Domain.api}/auth/refresh';
  String get me => '${Domain.api}/auth/me';
}

class _ProductEndpoints {
  String get products => '${Domain.api}/products';
  String get create => '${Domain.api}/products/add';
  String get search => '${Domain.api}/products/search';
}
