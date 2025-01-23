// Data Layer
import 'package:customers/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> signInWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(username, password);
      return Right(user);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
