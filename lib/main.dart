import 'package:flutter/material.dart';
import 'package:provider_with_clean_arch/src/common/dependency_injectors/dependency_injector.dart';
import 'package:provider_with_clean_arch/src/common/patterns/state_pattern.dart';
import 'package:provider_with_clean_arch/src/common/routes/routes.dart';
import 'package:provider_with_clean_arch/src/common/state_management/state_management.dart';
import 'package:provider_with_clean_arch/src/features/settings/presentation/presentation.dart';

void main() {
  final Routes appRoutes = Routes();
  runApp(DependencyInjector(child: MyApp(appRoutes: appRoutes)));
}

class MyApp extends StatelessWidget {
  final Routes appRoutes;

  const MyApp({super.key, required this.appRoutes});

  @override
  Widget build(BuildContext context) {
    final settingViewModel = context.observe<SettingViewModel>();
    return StateBuilderWidget<SettingViewModel, SettingsState>(
      viewModel: settingViewModel,
      builder: (context, settingState) {
        final isDarkTheme = switch (settingState) {
          SuccessState(data: final setting) => setting.isDarkTheme,
          _ => false,
        };
        return MaterialApp.router(
          title: 'Provider With Clean Arch',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          routerConfig: appRoutes.routes,
        );
      },
    );
  }
}
