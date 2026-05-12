import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:home_test_prudential/infrastructure/dal/models/pagination_filter.dart';
import '../../core/errors/failures.dart';
import '../entities/products_entity.dart';
import '../repositories/products_repository.dart';
import '../../../infrastructure/dal/services/products_api_service.dart';
import '../../../utils/json_parser.dart';
import '../models/products_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsApiService apiService;

  ProductsRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, ProductsEntity>> getProducts(
    PaginationFilter filter,
  ) async {
    try {
      final response = await apiService.getProducts(
        queryParameters: filter.toJson(),
      );
      if (response.statusCode == 200) {
        final products = JsonParser.parseObject(
          json: response.data,
          fromJson: ProductsModel.fromJson,
        );
        return Right(products);
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
