import 'package:bilineo/request/constants.dart';
import 'package:bilineo/request/request.dart';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class SetCookie {
  // 不适用于桌面端
  static onSet() async {
    var cookies = await WebviewCookieManager().getCookies(HttpString.baseUrl);
    await Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.baseUrl), cookies);
    var cookieString =
        cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    Request.dio.options.headers['cookie'] = cookieString;

    // Debug
    debugPrint('移动端调试 当前baseCookie 为 $cookieString');

    cookies = await WebviewCookieManager().getCookies(HttpString.apiBaseUrl);
    await Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.apiBaseUrl), cookies);

    cookies.forEach((cookie) {
      debugPrint('移动端调试 当前apicookie: ${cookie.name}: ${cookie.value}');
    });

    cookies = await WebviewCookieManager().getCookies(HttpString.tUrl);
    await Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.tUrl), cookies);
  }
}
