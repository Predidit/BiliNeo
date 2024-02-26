import 'package:flutter/material.dart';
import 'package:bilineo/app_module.dart';
import 'package:bilineo/app_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}
