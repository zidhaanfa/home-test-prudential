import 'package:home_test_prudential/infrastructure/platform/secure_storage/flutter_secure_storage_impl.dart';

class Routes {
  static Future<String> get initialRoute async {
    final secureStorage = FlutterSecureStorageImpl();
    if (await secureStorage.read(SecureStorageKey.accessToken) != null) {
      return navigation;
    } else {
      return login;
    }
  }

  static const home = '/home';
  static const login = '/login';
  static const navigation = '/navigation';
  static const products = '/products';
  static const profile = '/profile';
  static const user = '/user';
  static const comingSoon = '/coming-soon';
  static const addProduct = '/add-product';
}
