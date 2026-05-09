import 'package:provider_with_clean_arch/src/features/users/data/data_sources/user_data_source.dart';
import 'package:provider_with_clean_arch/src/features/users/domain/domain.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource userDataSource;

  UserRepositoryImpl({required this.userDataSource});

  @override
  Future<UserResult> findAllUsers() async {
    try {
      return await userDataSource.findAllUsers();
    } catch (error) {
      throw Exception('SettingRepository: $error');
    }
  }
}
