import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class GStorage {
  static late final Box<dynamic> localCache;

  static Future<void> init() async {
    final Directory dir = await getApplicationSupportDirectory();
    final String path = dir.path;
    await Hive.initFlutter('$path/hive');
    // 本地缓存
    localCache = await Hive.openBox(
      'localCache',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 4;
      },
    );
  }
}

class LocalCacheKey {
  // 历史记录暂停状态 默认false 记录
  static const String historyPause = 'historyPause',
      // access_key
      accessKey = 'accessKey',

      //
      wbiKeys = 'wbiKeys',
      timeStamp = 'timeStamp',

      // 弹幕相关设置 屏蔽类型 显示区域 透明度 字体大小 弹幕时间 描边粗细
      danmakuBlockType = 'danmakuBlockType',
      danmakuShowArea = 'danmakuShowArea',
      danmakuOpacity = 'danmakuOpacity',
      danmakuFontScale = 'danmakuFontScale',
      danmakuDuration = 'danmakuDuration',
      strokeWidth = 'strokeWidth',

      // 代理host port
      systemProxyHost = 'systemProxyHost',
      systemProxyPort = 'systemProxyPort';
}
