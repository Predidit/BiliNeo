import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:bilineo/request/search.dart';
import 'package:bilineo/pages/player/search_type.dart';
import 'package:bilineo/utils/utils.dart';
import 'package:bilineo/utils/id.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/video/video_controller.dart';

part 'results_controller.g.dart';

class SearchResultController = _SearchResultController
    with _$SearchResultController;

abstract class _SearchResultController with Store {
  ScrollController scrollController = ScrollController();
  final VideoController videoController = Modular.get<VideoController>();

  @observable
  String searchKeyWord = '';

  @observable
  int page = 1;

  @observable
  List resultList = [];

  SearchType searchType = SearchType.media_bangumi;

  Future onSearch({type = 'init'}) async {
    if (type == 'init') {
      page = 1;
    }
    var result = await SearchHttp.searchByType(
        searchType: searchType,
        keyword: searchKeyWord,
        page: page,
        order: null,
        duration: null);
    if (result['status']) {
      if (type == 'onRefresh' || type == 'init') {
        resultList = result['data'].list;
      } else {
        resultList.addAll(result['data'].list);
      }
      page++;
      onPushDetail(searchKeyWord, resultList);
    }
    return result;
  }

  Future onRefresh() async {
    page = 1;
    await onSearch(type: 'onRefresh');
  }

  void onPushDetail(keyword, resultList) async {
    // 匹配输入内容，如果是AV、BV号且有结果 直接跳转详情页
    Map matchRes = IdUtils.matchAvorBv(input: keyword);
    List matchKeys = matchRes.keys.toList();
    String? bvid;
    try {
      bvid = resultList.first.bvid;
    } catch (_) {
      bvid = null;
    }
    // keyword 可能输入纯数字
    int? aid;
    try {
      aid = resultList.first.aid;
    } catch (_) {
      aid = null;
    }
    if (matchKeys.isNotEmpty && searchType == SearchType.video ||
        aid.toString() == keyword) {
      String heroTag = Utils.makeHeroTag(bvid);
      int cid = await SearchHttp.ab2c(aid: aid, bvid: bvid);
      if (matchKeys.isNotEmpty &&
              matchKeys.first == 'BV' &&
              matchRes[matchKeys.first] == bvid ||
          matchKeys.isNotEmpty &&
              matchKeys.first == 'AV' &&
              matchRes[matchKeys.first] == aid ||
          aid.toString() == keyword) {
        // Get.toNamed(
        //   '/video?bvid=$bvid&cid=$cid',
        //   arguments: {'videoItem': resultList.first, 'heroTag': heroTag},
        // );
        videoController.bvid = bvid ?? '';
        videoController.cid = cid;
        videoController.heroTag = heroTag;
        videoController.videoType = SearchType.media_bangumi;
        // videoController.bangumiItem = res['data'];
        Modular.to.navigate('/tab/video/');
      }
    }
  }
}
