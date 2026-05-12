import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/failures.dart';
import '../../../utils/json_parser.dart';
import '../entities/profile_entity.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';
import '../../../infrastructure/dal/services/profile_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService apiService;

  ProfileRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final response = await apiService.getProfile();
      if (response.statusCode == 200) {
        final profile = JsonParser.parseObject(
          json: response.data,
          fromJson: ProfileModel.fromJson,
        );
        return Right(profile);
      } else {
        return Left(ServerFailure(response.statusMessage ?? 'Server Error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network Error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected Error Occurred'));
    }
  }
}
