import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:bilineo/pages/my/user_info.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:bilineo/pages/webview/webview_controller.dart';
import 'package:bilineo/request/request.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:bilineo/pages/popular/popular_controller.dart';
import 'package:webview_windows/webview_windows.dart' as desktopWebview;

// import 'package:webview_flutter/webview_flutter.dart';

part 'my_controller.g.dart';

class MyController = _MyController with _$MyController;

abstract class _MyController with Store {
  final userInfo = Modular.get<UserInfoData>();
  final PopularController popularController = Modular.get<PopularController>();

  @observable
  bool userLogin = false;

  @observable
  String userFace = '';

  @observable
  String uname = '';

  @observable
  int currentLevel = 0;

  Box userInfoCache = GStorage.userInfo;
  final webController = Modular.get<WebviewController>();
  // Todo 设置相关
  // Box setting = GStorage.setting;

  onInit() {
    if (userInfoCache.get('userInfoCache') != null) {
      debugPrint('登录状态初始化成功 ${userInfoCache.get('userInfoCache').toString()} ');
      updateLoginStatus(true);
    }
  }

  onLogin() async {
    if (!userLogin && !Platform.isWindows) {
      webController.url = 'https://passport.bilibili.com/h5-app/passport/login';
      webController.type = 'login';
      webController.pageTitle = '登录bilibili';
      webController.init();
      Modular.to.navigate('/tab/webview/');
    }
    if (!userLogin && Platform.isWindows) {
      Modular.to.navigate('/tab/webviewdesktop/');
    }
  }

  loginOut() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确认要退出登录吗'),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: const Text('点错了'),
            ),
            TextButton(
              onPressed: () async {
                // 清空cookie
                await Request.cookieManager.cookieJar.deleteAll();
                Request.dio.options.headers['cookie'] = '';

                // 清空本地存储的用户标识
                userInfoCache.put('userInfoCache', null);

                // 清除webview2缓存
                if (Platform.isWindows) {
                  final _controller = desktopWebview.WebviewController();
                  await _controller.initialize();
                  await _controller.clearCookies();
                  await _controller.clearCache();
                  await _controller.dispose();
                }

                //// Todo 暂缓处理
                // localCache
                //     .put(LocalCacheKey.accessKey, {'mid': -1, 'value': ''});

                updateLoginStatus(false);
                
                SmartDialog.dismiss()
                    .then((value) => Modular.to.navigate('/tab/my/'));
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  void updateLoginStatus(val) async {
    var userInfoMap = userInfoCache.get('userInfoCache');
    userInfo.emailVerified = userInfoMap?.emailVerified;
    userInfo.face = userInfoMap?.face;
    userInfo.hasShop = userInfoMap?.hasShop;
    userInfo.isLogin = userInfoMap?.isLogin;
    userInfo.levelInfo = userInfoMap?.levelInfo;
    userInfo.mid = userInfoMap?.mid;
    userInfo.mobileVerified = userInfoMap?.mobileVerified;
    userInfo.money = userInfoMap?.money;
    userInfo.moral = userInfoMap?.moral;
    userInfo.official = userInfoMap?.official;
    userInfo.officialVerify = userInfoMap?.officialVerify;
    userInfo.pendant = userInfoMap?.pendant;
    userInfo.scores = userInfoMap?.scores;
    userInfo.shopUrl = userInfoMap?.shopUrl;
    userInfo.uname = userInfoMap?.uname;
    userInfo.vipAvatarSub = userInfoMap?.vipAvatarSub;
    userInfo.vipDueDate = userInfoMap?.vipDueDate;
    userInfo.vipLabel = userInfoMap?.vipLabel;
    userInfo.vipNicknameColor = userInfoMap?.vipNicknameColor;
    userInfo.vipPayType = userInfoMap?.vipPayType;
    userInfo.vipStatus = userInfoMap?.vipStatus;
    userInfo.vipThemeType = userInfoMap?.vipThemeType;
    userInfo.vipType = userInfoMap?.vipType;
    userInfo.wallet = userInfoMap?.wallet;
    userFace = userInfoMap?.face ?? '';
    uname = userInfoMap?.uname ?? '';
    
    if (val) {
      currentLevel = userInfoMap?.levelInfo!.currentLevel ?? 0;
      debugPrint('登录状态刷新成功 ${userInfoCache.get('userInfoCache').uname} ');
    } else {
      currentLevel = 0;
    }

    // userInfo.init(userInfoMap);
    userLogin = val ?? false;
    // if (val) return;
    //// 头像相关
    // userFace.value = userInfo != null ? userInfo.face : '';
  }
  clearPopularCache() {
    popularController.bangumiList.clear();
  }
}
