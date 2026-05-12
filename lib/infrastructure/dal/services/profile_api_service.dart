import 'package:dio/dio.dart';
import '../../network/dio_client.dart';
import '../../network/url.dart';
import '../../platform/secure_storage/secure_storage.dart';

class ProfileApiService {
  final SecureStorage secureStorage;

  ProfileApiService({required this.secureStorage});

  Dio get _authClient => DioClient.authClient(secureStorage);

  Future<Response> getProfile() async {
    return await _authClient.get(Endpoint.auth.me);
  }
}
