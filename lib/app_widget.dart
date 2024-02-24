import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    var app = MaterialApp.router(
      title: "Mastodon for Flutter",
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: "CN")],
      locale: const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: "CN"),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.purple,
      ),
      routerConfig: Modular.routerConfig,
      builder: Asuka.builder,
      // navigatorObservers: [Asuka.asukaHeroController],
    );
    Modular.setObservers([Asuka.asukaHeroController]);
    return app;
  }
}
