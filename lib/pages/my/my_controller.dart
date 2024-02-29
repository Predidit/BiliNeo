import 'dart:js_interop';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:bilineo/pages/my/user_info.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:hive/hive.dart';

part 'my_controller.g.dart';

class MyController = _MyController with _$MyController;

abstract class _MyController with Store {
  @observable
  final userInfo = Modular.get<UserInfoData>();

  @observable
  bool userLogin = false;

  Box userInfoCache = GStorage.userInfo;
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
      Get.toNamed(
        '/webview',
        parameters: {
          'url': 'https://passport.bilibili.com/h5-app/passport/login',
          'type': 'login',
          'pageTitle': '登录bilibili',
        },
      );
      // Get.toNamed('/loginPage');
    } 
  }
}
