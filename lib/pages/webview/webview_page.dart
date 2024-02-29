import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/webview/webview_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final _webviewController = Modular.get<WebviewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: Text(
            _webviewController.pageTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            const SizedBox(width: 4),
            IconButton(
              onPressed: () {
                _webviewController.controller.reload();
              },
              icon: Icon(Icons.refresh_outlined,
                  color: Theme.of(context).colorScheme.primary),
            ),
            IconButton(
              onPressed: () {
                launchUrl(Uri.parse(_webviewController.url));
              },
              icon: Icon(Icons.open_in_browser_outlined,
                  color: Theme.of(context).colorScheme.primary),
            ),
            Observer(builder: (context) {
              return _webviewController.type == 'login'
                  ? TextButton(
                      onPressed: () => _webviewController.confirmLogin(null),
                      child: const Text('刷新登录状态'),
                    )
                  : const SizedBox();
            }),
            const SizedBox(width: 12)
          ],
        ),
        body: Column(
          children: [
            Observer(builder: (context) {
              return AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 350),
                height: _webviewController.loadShow ? 4 : 0,
                child: LinearProgressIndicator(
                  key: ValueKey(_webviewController.loadProgress),
                  value: _webviewController.loadProgress / 100,
                ),
              );
            }),
            if (_webviewController.type == 'login')
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.onInverseSurface,
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 6, bottom: 6),
                child: const Text('登录成功未自动跳转?  请点击右上角「刷新登录状态」'),
              ),
            Expanded(
              child: WebViewWidget(controller: _webviewController.controller),
            ),
          ],
        ));
  }
}
