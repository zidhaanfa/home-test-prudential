import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import '../../../infrastructure/platform/secure_storage/flutter_secure_storage_impl.dart';
import '../../../infrastructure/platform/secure_storage/secure_storage.dart';
// import '../../../infrastructure/platform/storage/get_storage_impl.dart';
import '../../../infrastructure/dal/services/auth_api_service.dart';
import '../models/login_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  // final GetStorageImpl storage;
  final SecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.apiService,
    // required this.storage,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, LoginEntity>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await apiService.login({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data == null) {
          return Left(ServerFailure('Data not found'));
        }

        final loginModel = LoginModel.fromJson(data);

        // Simpan token ke SecureStorage (encrypted)
        await secureStorage.write(
          SecureStorageKey.accessToken,
          loginModel.accessToken,
        );
        await secureStorage.write(
          SecureStorageKey.refreshToken,
          loginModel.refreshToken,
        );
        return Right(loginModel);
      } else {
        return Left(ServerFailure(response.statusMessage ?? 'Server Error'));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return Left(
          ServerFailure(e.response?.data['message'] ?? 'Invalid credentials'),
        );
      }
      return Left(ServerFailure(e.message ?? 'Network Error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected Error Occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Hapus token dari SecureStorage
      await secureStorage.delete(SecureStorageKey.accessToken);
      await secureStorage.delete(SecureStorageKey.refreshToken);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear secure storage'));
    }
  }
}
