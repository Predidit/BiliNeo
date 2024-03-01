import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:bilineo/pages/my/user_info.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:bilineo/pages/webview/webview_controller.dart';
// import 'package:webview_flutter/webview_flutter.dart';

part 'my_controller.g.dart';

class MyController = _MyController with _$MyController;

abstract class _MyController with Store {
  final userInfo = Modular.get<UserInfoData>();

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
      // 魔改hive模型逻辑，可能有坑
      // Map<String, dynamic> jsonMap =
      //     jsonDecode(userInfoCache.get('userInfoCache').toString());
      // var userInfoMap = userInfoCache.get('userInfoCache');
      // userInfo.init(userInfoMap);
      updateLoginStatus(true);
      // userLogin = true;
    }
  }

  onLogin() async {
    if (!userLogin) {
      webController.url = 'https://passport.bilibili.com/h5-app/passport/login';
      webController.type = 'login';
      webController.pageTitle = '登录bilibili';
      webController.init();
      Modular.to.pushNamed('/tab/webview/');
    }
  }

  void updateLoginStatus(val) async {
    debugPrint('登录状态刷新成功 ${userInfoCache.get('userInfoCache').uname} ');
    UserInfoData userInfoMap = userInfoCache.get('userInfoCache');
    userInfo.emailVerified = userInfoMap.emailVerified;
    userInfo.face = userInfoMap.face;
    userInfo.hasShop = userInfoMap.hasShop;
    userInfo.isLogin = userInfoMap.isLogin;
    userInfo.levelInfo = userInfoMap.levelInfo;
    userInfo.mid = userInfoMap.mid;
    userInfo.mobileVerified = userInfoMap.mobileVerified;
    userInfo.money = userInfoMap.money;
    userInfo.moral = userInfoMap.moral;
    userInfo.official = userInfoMap.official;
    userInfo.officialVerify = userInfoMap.officialVerify;
    userInfo.pendant = userInfoMap.pendant;
    userInfo.scores = userInfoMap.scores;
    userInfo.shopUrl = userInfoMap.shopUrl;
    userInfo.uname = userInfoMap.uname;
    userInfo.vipAvatarSub = userInfoMap.vipAvatarSub;
    userInfo.vipDueDate = userInfoMap.vipDueDate;
    userInfo.vipLabel = userInfoMap.vipLabel;
    userInfo.vipNicknameColor = userInfoMap.vipNicknameColor;
    userInfo.vipPayType = userInfoMap.vipPayType;
    userInfo.vipStatus = userInfoMap.vipStatus;
    userInfo.vipThemeType = userInfoMap.vipThemeType;
    userInfo.vipType = userInfoMap.vipType;
    userInfo.wallet = userInfoMap.wallet;
    // userInfo.init(userInfoMap);
    userLogin = val ?? false;
    // if (val) return;
    //// 头像相关
    // userFace.value = userInfo != null ? userInfo.face : '';

    userFace = userInfoMap.face ?? '';
    uname = userInfoMap.uname ?? '';
    currentLevel = userInfoMap.levelInfo!.currentLevel ?? 0;
  } 
}
