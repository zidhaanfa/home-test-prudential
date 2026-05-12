import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/products_entity.dart';
import '../repositories/products_repository.dart';

class DeleteProductUseCase implements UseCase<ProductEntity, String> {
  final ProductsRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> execute(String params) async {
    return await repository.deleteProduct(params);
  }
}
