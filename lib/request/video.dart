import 'package:flutter/material.dart';
import 'dart:convert';

import 'api.dart';
import 'request.dart';
import 'package:hive/hive.dart';
import 'package:bilineo/utils/wbisign.dart';
import 'package:bilineo/pages/player/player_url.dart';
import 'package:bilineo/utils/utils.dart';

class VideoRequest {
// Todo 获取字幕
  static Future subUrl({int? avid, String? bvid, required int cid}) async {
    Map<String, dynamic> data = {
      'cid': cid,
      'bvid': bvid,
    };
    if (avid != null) {
      data['avid'] = avid;
    }
    Map params = await WbiSign().makSign({
      ...data,
      'fourk': 1,
      'voice_balance': 1,
      'gaia_source': 'pre-load',
      'web_location': 1550101,
    });
    try {
      var res = await Request().get(Api.subUrl, data: params);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      List<dynamic> subtitles = jsonMap['data']['subtitle']['subtitles'];
      String subtitleUrl = subtitles.firstWhere(
          (subtitle) => subtitle['lan'].startsWith('zh'),
          orElse: () => null)['subtitle_url'];
      subtitleUrl = 'https:' + subtitleUrl;
      debugPrint(subtitleUrl);
      return subtitleUrl;
    } catch (e) {
      debugPrint('查询字幕失败 ${e.toString()}');
      return '';
    }
  }

  static Future getSub(String subUrl) async{
    var res = await Request().get(subUrl);
    final jsonData = json.decode(res.toString());
    final webvttString = Utils.jsonToWebVTT(jsonData);
    // debugPrint(webvttString);
    return webvttString;
  }

  static Future videoUrl(
      {int? avid, String? bvid, required int cid, int? qn}) async {
    Map<String, dynamic> data = {
      'cid': cid,
      'qn': qn ?? 80,
      // 获取所有格式的视频
      'fnval': 4048,
    };
    if (avid != null) {
      data['avid'] = avid;
    }
    if (bvid != null) {
      data['bvid'] = bvid;
    }

    // Todo 大会员相关

    // 免登录查看1080p
    // if (userInfoCache.get('userInfoCache') == null &&
    //     setting.get(SettingBoxKey.p1080, defaultValue: true)) {
    //   data['try_look'] = 1;
    // }

    data['try_look'] = 1;

    Map params = await WbiSign().makSign({
      ...data,
      'fourk': 1,
      'voice_balance': 1,
      'gaia_source': 'pre-load',
      'web_location': 1550101,
    });

    try {
      var res = await Request().get(Api.videoUrl, data: params);
      if (res.data['code'] == 0) {
        return {
          'status': true,
          'data': PlayUrlModel.fromJson(res.data['data'])
        };
      } else {
        return {
          'status': false,
          'data': [],
          'code': res.data['code'],
          'msg': res.data['message'],
        };
      }
    } catch (err) {
      return {'status': false, 'data': [], 'msg': err};
    }
  }
}
