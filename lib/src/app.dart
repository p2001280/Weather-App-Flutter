import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:weather_app_v2/screens/WeatherScreen.dart';
import 'package:weather_app_v2/screens/WeeklyWeatherScreen.dart';
import 'package:weather_app_v2/src/settings/settings_controller.dart';
import 'package:weather_app_v2/src/settings/settings_view.dart';

void main() {
  final SettingsController settingsController = SettingsController();
  runApp(MyApp(settingsController: settingsController));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                inspect(routeSettings);
                print(routeSettings);
                switch (routeSettings.name) {
                  case '/settings':
                    return SettingsView(controller: settingsController);
                  default:
                    return const WeeklyWeatherScreen(); // Afficher l'écran météo par défaut si l'itinéraire est inconnu
                }
              },
            );
          },
        );
      },
    );
  }
}
