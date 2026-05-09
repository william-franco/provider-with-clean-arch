import 'package:go_router/go_router.dart';
import 'package:provider_with_clean_arch/src/common/state_management/state_management.dart';
import 'package:provider_with_clean_arch/src/features/settings/presentation/presentation.dart';

class SettingRoutes {
  static String get setting => '/setting';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: setting,
      builder: (context, state) {
        return SettingView(
          settingViewModel: context.inject<SettingViewModel>(),
        );
      },
    ),
  ];
}
