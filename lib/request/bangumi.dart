import 'package:bilineo/request/request.dart';
import 'package:bilineo/request/api.dart';
import 'package:bilineo/bean/bangumi/bangumi_list.dart';

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
