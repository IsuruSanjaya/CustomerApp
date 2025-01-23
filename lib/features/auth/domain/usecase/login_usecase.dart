import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, User>> call(String username, String password) {
    return repository.signInWithUsernamePassword(
      username: username,
      password: password,
    );
  }
}