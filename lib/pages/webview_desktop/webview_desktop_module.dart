import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/webview_desktop/webview_desktop_page.dart';

class WebviewDesktopMoudle extends Module {
  @override
  void binds(i) {
    // i.addSingleton();
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const WebviewDesktopPage());
  }
}