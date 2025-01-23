import 'package:customers/core/error/failure.dart';
import 'package:customers/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithUsernamePassword({
    required String username,
    required String password,
  });
}
