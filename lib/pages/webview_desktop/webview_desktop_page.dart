import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/webview_desktop/webview_desktop_controller.dart';
import 'package:webview_windows/webview_windows.dart';

class WebviewDesktopPage extends StatefulWidget {
  const WebviewDesktopPage({super.key});

  @override
  State<WebviewDesktopPage> createState() => _WebviewDesktopPageState();
}

class _WebviewDesktopPageState extends State<WebviewDesktopPage> {
  final _controller = WebviewController();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await _controller.initialize();
    await _controller.loadUrl('https://passport.bilibili.com/h5-app/passport/login');
    // LISTEN DATA FROM HTML CONTENT
    _controller.webMessage.listen((event) {
      debugPrint(event);
    });
    if (!mounted) return;

    setState(() {});
  }

  Widget get compositeView {
    if (!_controller.value.isInitialized) {
      return const Text(
        'Not Initialized',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              Webview(_controller),
              StreamBuilder<LoadingState>(
                  stream: _controller.loadingState,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data == LoadingState.loading) {
                      return const LinearProgressIndicator();
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('windows webview test'),
      ),
      body: compositeView,
    );
  }
}
