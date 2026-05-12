import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/products_entity.dart';
import '../repositories/products_repository.dart';

class GetProductDetailUseCase implements UseCase<ProductEntity, String> {
  final ProductsRepository repository;

  GetProductDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, ProductEntity>> execute(String params) {
    return repository.getProductDetail(params);
  }
}
