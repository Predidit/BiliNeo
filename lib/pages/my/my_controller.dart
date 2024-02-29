import 'dart:js_interop';

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

  Box userInfoCache = GStorage.userInfo;
  final webController = Modular.get<WebviewController>();
  // Todo 设置相关
  // Box setting = GStorage.setting;

  onInit() {
    if (userInfoCache.get('userInfoCache') != null) {
      // 魔改hive模型逻辑，可能有坑
      userInfo.init(userInfoCache.get('userInfoCache'));
      userLogin = true;
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
    userInfo.init(userInfoCache.get('userInfoCache'));
    userLogin = val ?? false;
    if (val) return; 
    //// 头像相关
    // userFace.value = userInfo != null ? userInfo.face : '';
  }
}
