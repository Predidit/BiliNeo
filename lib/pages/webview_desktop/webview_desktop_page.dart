import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:bilineo/request/user.dart';
import 'package:flutter/services.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:bilineo/pages/my/my_controller.dart';
import 'package:bilineo/request/request.dart';
import 'package:bilineo/request/constants.dart';
import 'package:cookie_jar/cookie_jar.dart';

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
    await _controller.loadUrl('https://passport.bilibili.com/login');
    // LISTEN DATA FROM HTML CONTENT
    _controller.webMessage.listen((event) async {
      debugPrint(event);
    });
    if (!mounted) return;

    setState(() {});
  }

  confirmLogin() async {
    String baseCookieString =
        await _controller.getCookies(HttpString.baseUrl) ?? '';
    baseCookieString =
        baseCookieString.substring(0, baseCookieString.length - 1);
    
    debugPrint('处理前baseCookie为 $baseCookieString');
    await Request.cookieManager.cookieJar.delete(Uri.parse(HttpString.baseUrl));
    await Request.cookieManager.cookieJar
        .delete(Uri.parse(HttpString.apiBaseUrl));
    Request.dio.options.headers['cookie'] = baseCookieString;

    List<Cookie> baseCookies = [];
    baseCookieString.split(';').forEach((cookieString) {
      List<String> cookieParts = cookieString.split('=');
      Cookie cookie = Cookie(cookieParts[0], cookieParts[1]);
      if (cookieParts[0] == '_uuid' ||
          cookieParts[0] == 'buvid3' ||
          cookieParts[0] == 'buvid4' ||
          cookieParts[0] == 'SESSDATA' ||
          cookieParts[0] == 'bili_jct' ||
          cookieParts[0] == 'DedeUserID' ||
          cookieParts[0] == 'DedeUserID__ckMd5' ||
          cookieParts[0] == 'sid') {
        baseCookies.add(cookie);
      }
    });

    await Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.baseUrl), baseCookies);
    await Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.apiBaseUrl), baseCookies);
        await Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.unlockAPIUrl), baseCookies);
    List<Cookie> baseCookiesDebug = await Request.cookieManager.cookieJar
        .loadForRequest(Uri.parse(HttpString.baseUrl));
    baseCookiesDebug.forEach((cookie) {
      debugPrint('本地 Base cookie: ${cookie.name}: ${cookie.value}');
    });
    List<Cookie> apiCookiesDebug = await Request.cookieManager.cookieJar
        .loadForRequest(Uri.parse(HttpString.apiBaseUrl));
    apiCookiesDebug.forEach((cookie) {
      debugPrint('本地 API cookie: ${cookie.name}: ${cookie.value}');
    });
    final result = await UserHttp.userInfo();
    try {
      // Todo Panic
      // await SetCookie.onSet();
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
          SmartDialog.showToast(err.toString());
        }
        // Get.back();
        Modular.to.navigate('/tab/my/');
      } else {
        // 获取用户信息失败
        SmartDialog.showToast('获取用户信息失败 ${result.toString()}');
        debugPrint('获取用户信息失败 ${result.toString()}');
      }
    } catch (e) {
      debugPrint('登录检查点失败');
      SmartDialog.showNotify(msg: e.toString(), notifyType: NotifyType.warning);
    }
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
              StreamBuilder<String>(
                stream: _controller.url,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      (snapshot.data ?? '')
                          .startsWith(HttpString.baseUrl)) {
                    // Todo 执行cookie获取函数
                    // _controller.executeScript('window.chrome.webview.postMessage("愿原力与你同在")');
                    debugPrint('URL匹配成功, 正在获取baseCookie');
                    _controller.loadUrl(
                        HttpString.apiBaseUrl + '/x/web-interface/nav');
                    return Container();
                  }
                  if (snapshot.hasData &&
                      (snapshot.data ?? '')
                          .startsWith(HttpString.apiBaseUrl)) {
                    debugPrint('URL匹配成功, 正在获取apiCookie');
                    confirmLogin();
                  }
                  return Container();
                },
              ),
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
        title: const Text('Bilibili 登录'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Modular.to.navigate('/tab/my/');
            //Modular.to.pop();
          },
        ),
      ),
      body: compositeView,
    );
  }
  
}
