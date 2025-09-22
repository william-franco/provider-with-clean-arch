import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_with_clean_arch/src/common/services/connection_service.dart';
import 'package:provider_with_clean_arch/src/common/services/http_service.dart';
import 'package:provider_with_clean_arch/src/common/services/storage_service.dart';
import 'package:provider_with_clean_arch/src/features/settings/data/data_sources/setting_data_source.dart';
import 'package:provider_with_clean_arch/src/features/settings/data/data_sources/setting_data_source_impl.dart';
import 'package:provider_with_clean_arch/src/features/settings/data/repositories/setting_repository_impl.dart';
import 'package:provider_with_clean_arch/src/features/settings/domain/repositories/setting_repository.dart';
import 'package:provider_with_clean_arch/src/features/settings/domain/usecases/read_theme_use_case.dart';
import 'package:provider_with_clean_arch/src/features/settings/domain/usecases/update_theme_use_case.dart';
import 'package:provider_with_clean_arch/src/features/settings/presentation/view_models/setting_view_model.dart';
import 'package:provider_with_clean_arch/src/features/users/data/data_sources/user_data_source.dart';
import 'package:provider_with_clean_arch/src/features/users/data/data_sources/user_data_source_impl.dart';
import 'package:provider_with_clean_arch/src/features/users/data/repositories/user_repository_impl.dart';
import 'package:provider_with_clean_arch/src/features/users/domain/repositories/user_repository.dart';
import 'package:provider_with_clean_arch/src/features/users/domain/usecases/get_all_users_use_case.dart';
import 'package:provider_with_clean_arch/src/features/users/presentation/view_models/user_view_model.dart';

class DependencyInjector extends StatefulWidget {
  final Widget child;

  const DependencyInjector({super.key, required this.child});

  @override
  State<DependencyInjector> createState() => _DependencyInjectorState();
}

class _DependencyInjectorState extends State<DependencyInjector> {
  // Services
  late final ConnectionService connectionService;
  late final HttpService httpService;
  late final StorageService storageService;

  // Data Sources
  late final SettingDataSource settingDataSource;
  late final UserDataSource userDataSource;

  // Repositories
  late final SettingRepository settingRepository;
  late final UserRepository userRepository;

  // Use Cases
  late final ReadThemeUseCase readThemeUseCase;
  late final UpdateThemeUseCase updateThemeUseCase;
  late final GetAllUsersUseCase getAllUsersUseCase;

  // ViewModels
  late final SettingViewModel settingViewModel;
  late final UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    // Services
    connectionService = ConnectionServiceImpl();
    httpService = HttpServiceImpl();
    storageService = StorageServiceImpl();

    // Data Sources
    settingDataSource = SettingDataSourceImpl(storageService: storageService);
    userDataSource = UserDataSourceImpl(
      connectionService: connectionService,
      httpService: httpService,
    );

    // Repositories
    settingRepository = SettingRepositoryImpl(
      settingDataSource: settingDataSource,
    );
    userRepository = UserRepositoryImpl(userDataSource: userDataSource);

    // Use Cases
    readThemeUseCase = ReadThemeUseCaseImpl(
      settingRepository: settingRepository,
    );
    updateThemeUseCase = UpdateThemeUseCaseImpl(
      settingRepository: settingRepository,
    );
    getAllUsersUseCase = GetAllUsersUseCaseImpl(userRepository: userRepository);

    // ViewModels
    settingViewModel = SettingViewModelImpl(
      readThemeUseCase: readThemeUseCase,
      updateThemeUseCase: updateThemeUseCase,
    );
    userViewModel = UserViewModelImpl(getAllUsersUseCase: getAllUsersUseCase);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initDependencies();
    });
  }

  Future<void> _initDependencies() async {
    await Future.wait([
      connectionService.checkConnection(),
      storageService.initStorage(),
    ]);
    await settingViewModel.getTheme();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<ConnectionService>.value(value: connectionService),
        Provider<HttpService>.value(value: httpService),
        Provider<StorageService>.value(value: storageService),
        // Data Sources
        Provider<SettingDataSource>.value(value: settingDataSource),
        Provider<UserDataSource>.value(value: userDataSource),
        // Repositories
        Provider<SettingRepository>.value(value: settingRepository),
        Provider<UserRepository>.value(value: userRepository),
        // Use Cases
        Provider<ReadThemeUseCase>.value(value: readThemeUseCase),
        Provider<UpdateThemeUseCase>.value(value: updateThemeUseCase),
        Provider<GetAllUsersUseCase>.value(value: getAllUsersUseCase),
        // ViewModels
        ChangeNotifierProvider<SettingViewModel>.value(value: settingViewModel),
        ChangeNotifierProvider<UserViewModel>.value(value: userViewModel),
      ],
      child: widget.child,
    );
  }
}
