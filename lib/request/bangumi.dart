import 'package:bilineo/request/request.dart';
import 'package:bilineo/request/api.dart';
import 'package:bilineo/bean/bangumi/bangumi_list.dart';
import 'package:bilineo/bean/bangumi/bangumi_info.dart';

class BangumiHttp {
  static Future bangumiList({int? page}) async {
    var res = await Request().get(Api.bangumiList, data: {'page': page});
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': BangumiListDataModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future<Map<String, dynamic>> bangumiInfo(
      {int? seasonId, int? epId}) async {
    final Map<String, dynamic> data = {};
    if (seasonId != null) {
      data['season_id'] = seasonId;
    } else if (epId != null) {
      data['ep_id'] = epId;
    }
    final dynamic res =
        await Request().get(Api.bangumiInfo, data: <String, dynamic>{...data});
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': BangumiInfoModel.fromJson(res.data['result']),
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': '请求错误 🙅',
      };
    }
  }

  static Future bangumiFollow({int? mid}) async {
    var res = await Request().get(Api.bangumiFollow, data: {'vmid': mid});
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': BangumiListDataModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
