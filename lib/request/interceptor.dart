// ignore_for_file: avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:bilineo/request/constants.dart';
import '../utils/storage.dart';

class ApiInterceptor extends Interceptor {
  static Box setting = GStorage.setting;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (setting.get(SettingBoxKey.aeraUnlock, defaultValue: false)) {
      debugPrint('当前解锁状态:已解锁');
      if (options.baseUrl == HttpString.apiBaseUrl) {
        debugPrint('使用 ${HttpString.unlockAPIUrl} 尝试解锁');
        options.baseUrl = HttpString.unlockAPIUrl;
      }
    } else {
      debugPrint('当前解锁状态:未解锁');
    }
    // ebugPrint("当前解锁状态 ${SettingBoxKey.aeraUnlock}");
    // 在请求之前添加头部或认证信息
    // options.headers['Authorization'] = 'Bearer token';
    // options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      if (response.statusCode == 302) {
        final List<String> locations = response.headers['location']!;
        if (locations.isNotEmpty) {
          if (locations.first.startsWith('https://www.mcbbs.net')) {
            final Uri uri = Uri.parse(locations.first);
            final String? accessKey = uri.queryParameters['access_key'];
            final String? mid = uri.queryParameters['mid'];
            try {
              Box localCache = GStorage.localCache;
              localCache.put(LocalCacheKey.accessKey,
                  <String, String?>{'mid': mid, 'value': accessKey});
            } catch (_) {}
          }
        }
      }
    } catch (err) {
      print('ApiInterceptor: $err');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理网络请求错误
    // handler.next(err);
    // SmartDialog.showToast(
    //   await dioError(err),
    //   displayType: SmartToastType.onlyRefresh,
    // );
    super.onError(err, handler);
  }

  static Future<String> dioError(DioException error) async {
    switch (error.type) {
      case DioExceptionType.badCertificate:
        return '证书有误！';
      case DioExceptionType.badResponse:
        return '服务器异常，请稍后重试！';
      case DioExceptionType.cancel:
        return '请求已被取消，请重新请求';
      case DioExceptionType.connectionError:
        return '连接错误，请检查网络设置';
      case DioExceptionType.connectionTimeout:
        return '网络连接超时，请检查网络设置';
      case DioExceptionType.receiveTimeout:
        return '响应超时，请稍后重试！';
      case DioExceptionType.sendTimeout:
        return '发送请求超时，请检查网络设置';
      case DioExceptionType.unknown:
        final String res = await checkConnect();
        return '$res，网络异常！如果您已打开港澳台模式，尝试关闭';
    }
  }

  static Future<String> checkConnect() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        return '正在使用移动流量';
      case ConnectivityResult.wifi:
        return '正在使用wifi';
      case ConnectivityResult.ethernet:
        return '正在使用局域网';
      case ConnectivityResult.vpn:
        return '正在使用代理网络';
      case ConnectivityResult.other:
        return '正在使用其他网络';
      case ConnectivityResult.none:
        return '未连接到任何网络';
      default:
        return '';
    }
  }
}
