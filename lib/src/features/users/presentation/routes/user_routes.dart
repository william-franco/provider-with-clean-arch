import 'package:go_router/go_router.dart';
import 'package:provider_with_clean_arch/src/common/state_management/state_management.dart';
import 'package:provider_with_clean_arch/src/features/users/domain/domain.dart';
import 'package:provider_with_clean_arch/src/features/users/presentation/presentation.dart';

class UserRoutes {
  static String get users => '/users';
  static String get userDetail => '/users-detail';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: users,
      builder: (context, state) {
        return UserView(userViewModel: context.inject<UserViewModel>());
      },
    ),
    GoRoute(
      path: userDetail,
      builder: (context, state) {
        final UserEntity userEntity = state.extra as UserEntity;

        return UserDetailView(userEntity: userEntity);
      },
    ),
  ];
}
