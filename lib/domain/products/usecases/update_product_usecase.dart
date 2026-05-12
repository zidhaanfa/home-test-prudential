import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../models/products_model.dart';
import '../repositories/products_repository.dart';

class UpdateProductUseCase extends UseCase<ProductModel, ProductModel> {
  final ProductsRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Either<Failure, ProductModel>> execute(ProductModel params) async {
    return await repository.updateProduct(params.id.toString(), params);
  }
}
