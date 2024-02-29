import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bilineo/request/request.dart';
import 'package:bilineo/utils/id.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:bilineo/pages/my/my_controller.dart';
import 'package:bilineo/request/cookie.dart';
import 'package:bilineo/request/user.dart';
import 'package:flutter/services.dart';

part 'webview_controller.g.dart';

class WebviewController = _WebviewController with _$WebviewController;

abstract class _WebviewController with Store {
  final WebViewController controller = WebViewController();
  @observable
  String type = '';

  @observable
  int loadProgress = 0;

  @observable
  bool loadShow = true;

  String url = '';
  String pageTitle = '';


  void init() {
    if (type == 'login') {
      controller.clearCache();
      controller.clearLocalStorage();
      WebViewCookieManager().clearCookies();
    }
    webviewInit();
  }

  webviewInit() {
    controller
      ..setUserAgent(Request().headerUa())
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // 页面加载
          onProgress: (int progress) {
            // Update loading bar.
            loadProgress = progress;
          },
          onPageStarted: (String url) {
            final String str = Uri.parse(url).pathSegments[0];
            final Map matchRes = IdUtils.matchAvorBv(input: str);
            final List matchKeys = matchRes.keys.toList();

            //// Todo 搜索相关
            // if (matchKeys.isNotEmpty) {
            //   if (matchKeys.first == 'BV') {
            //     Get.offAndToNamed(
            //       '/searchResult',
            //       parameters: {'keyword': matchRes['BV']},
            //     );
            //   }
            // }
          },
          // 加载完成
          onUrlChange: (UrlChange urlChange) async {
            loadShow = false;
            String url = urlChange.url ?? '';
            if (type == 'login' &&
                (url.startsWith(
                        'https://passport.bilibili.com/web/sso/exchange_cookie') ||
                    url.startsWith('https://m.bilibili.com/'))) {
              confirmLogin(url);
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {

            //// Todo 搜索相关
            // if (request.url.startsWith('bilibili://')) {
            //   if (request.url.startsWith('bilibili://video/')) {
            //     String str = Uri.parse(request.url).pathSegments[0];
            //     Get.offAndToNamed(
            //       '/searchResult',
            //       parameters: {'keyword': str},
            //     );
            //   }
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  confirmLogin(url) async {
    var content = '';
    if (url != null) {
      content = '${content + url}; \n';
    }
    try {
      await SetCookie.onSet();
      final result = await UserHttp.userInfo();
      if (result['status'] && result['data'].isLogin) {
        SmartDialog.showToast('登录成功');
        try {
          Box userInfoCache = GStorage.userInfo;
          await userInfoCache.put('userInfoCache', result['data']);
          final MyController homeCtr = Modular.get<MyController>();
          homeCtr.updateLoginStatus(true);
          homeCtr.userFace = result['data'].face;
          //// Todo 收藏功能
          // final MediaController mediaCtr = Get.find<MediaController>();
          // mediaCtr.mid = result['data'].mid;
          //// Todo 登录态
          // await LoginUtils.refreshLoginStatus(true);
        } catch (err) {
          SmartDialog.show(builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('登录遇到问题'),
              content: Text(err.toString()),
              actions: [
                TextButton(
                  onPressed: () => controller.reload(),
                  child: const Text('确认'),
                )
              ],
            );
          });
        }
        // Get.back();
        Modular.to.navigate('/tab/my/');
      } else {
        // 获取用户信息失败
        SmartDialog.showToast(result.msg);
        Clipboard.setData(ClipboardData(text: result.msg.toString()));
      }
    } catch (e) {
      SmartDialog.showNotify(msg: e.toString(), notifyType: NotifyType.warning);
      content = content + e.toString();
    }
    Clipboard.setData(ClipboardData(text: content));
  }
} 