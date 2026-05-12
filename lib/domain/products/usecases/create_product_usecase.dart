import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../models/products_model.dart';
import '../repositories/products_repository.dart';

class CreateProductUseCase implements UseCase<ProductModel, ProductModel> {
  final ProductsRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Either<Failure, ProductModel>> execute(ProductModel params) async {
    return await repository.createProduct(params);
  }
}
