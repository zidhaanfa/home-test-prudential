import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String username;
  final String password;

  LoginParams({required this.username, required this.password});
}

class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, LoginEntity>> execute(LoginParams params) {
    return repository.login(params.username, params.password);
  }
}
