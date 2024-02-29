import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/webview/webview_page.dart';

class WebviewMoudle extends Module {
  @override
  void routers(r) {
    r.child('/', child: (_) => const WebviewPage);
  }
}