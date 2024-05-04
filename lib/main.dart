import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bilineo/app_module.dart';
import 'package:bilineo/app_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:media_kit/media_kit.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:bilineo/request/request.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 830),
      center: true,
      // backgroundColor: Colors.white,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    windowManager.setMaximizable(false);
  }
  MediaKit.ensureInitialized();
  await GStorage.init();
  Request();
  await Request.setCookie();
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}
