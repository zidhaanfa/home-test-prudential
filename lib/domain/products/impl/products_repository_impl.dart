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
  // get products list
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

  // get product detail
  @override
  Future<Either<Failure, ProductEntity>> getProductDetail(
    String productId,
  ) async {
    try {
      final response = await apiService.getProductDetail(productId);
      if (response.statusCode == 200) {
        final product = JsonParser.parseObject(
          json: response.data,
          fromJson: ProductModel.fromJson,
        );
        return Right(product);
      } else {
        return Left(ServerFailure(response.statusMessage ?? 'Server Error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network Error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected Error Occurred'));
    }
  }

  // create product
  @override
  Future<Either<Failure, ProductModel>> createProduct(
    ProductModel product,
  ) async {
    try {
      final response = await apiService.createProduct(data: product.toJson());
      if (response.statusCode == 200) {
        final product = JsonParser.parseObject(
          json: response.data,
          fromJson: ProductModel.fromJson,
        );
        return Right(product);
      } else {
        return Left(ServerFailure(response.statusMessage ?? 'Server Error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network Error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected Error Occurred'));
    }
  }

  // update product
  @override
  Future<Either<Failure, ProductModel>> updateProduct(
    String id,
    ProductModel product,
  ) async {
    try {
      final response = await apiService.updateProduct(
        id: id,
        data: product.toJson(),
      );
      if (response.statusCode == 200) {
        final product = JsonParser.parseObject(
          json: response.data,
          fromJson: ProductModel.fromJson,
        );
        return Right(product);
      } else {
        return Left(ServerFailure(response.statusMessage ?? 'Server Error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network Error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected Error Occurred'));
    }
  }

  // delete product
  @override
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    try {
      final response = await apiService.deleteProduct(id);
      if (response.statusCode == 200) {
        return const Right(true);
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
