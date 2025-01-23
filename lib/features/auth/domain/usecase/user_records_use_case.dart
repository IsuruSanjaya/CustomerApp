
import '../../data/repositories/user_repository.dart';

class GetUserRecordsUseCase {
  final UserRepository userRepository;

  GetUserRecordsUseCase(this.userRepository);

  Future<List<Map<String, dynamic>>> execute() {
    return userRepository.getUserRecords();
  }
}



class DeleteUserUseCase {
  final UserRepository userRepository;

  DeleteUserUseCase(this.userRepository);

  Future<void> execute(String userCode) {
    return userRepository.deleteUser(userCode);
  }
}
