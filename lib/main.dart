import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bilineo/app_module.dart';
import 'package:bilineo/app_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:media_kit/media_kit.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:bilineo/request/request.dart';
// import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await GStorage.init();
  Request();
  await Request.setCookie();
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}
