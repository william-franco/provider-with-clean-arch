import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_with_clean_arch/src/common/dependency_injectors/dependency_injector.dart';
import 'package:provider_with_clean_arch/src/common/routes/routes.dart';
import 'package:provider_with_clean_arch/src/features/settings/presentation/view_models/setting_view_model.dart';

void main() {
  final Routes appRoutes = Routes();
  runApp(DependencyInjector(child: MyApp(appRoutes: appRoutes)));
}

class MyApp extends StatelessWidget {
  final Routes appRoutes;

  const MyApp({super.key, required this.appRoutes});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settingViewModel = context.watch<SettingViewModel>();
    return ListenableBuilder(
      listenable: settingViewModel,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Provider With Clean Arch',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: settingViewModel.settingEntity.isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: appRoutes.routes,
        );
      },
    );
  }
}
