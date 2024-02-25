import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:bilineo/request/bangumi.dart';
import 'package:bilineo/bean/bangumi/bangumi_list.dart';
import 'package:mobx/mobx.dart';

part 'popular_controller.g.dart';

class PopularController = _PopularController with _$PopularController;

abstract class _PopularController with Store {
  final ScrollController scrollController = ScrollController();

  @observable
  ObservableList<BangumiListItemModel> bangumiList = ObservableList.of([BangumiListItemModel()]);

  List<String> _items = [];
  List<String> get items => _items;
  List<BangumiListItemModel> get listValue => bangumiList.toList();

  int _currentPage = 1;
  bool isLoadingMore = true;

  @action
  Future queryBangumiListFeed({type = 'init'}) async {
    if (type == 'init') {
      _currentPage = 1;
    }
    var result = await BangumiHttp.bangumiList(page: _currentPage);
    if (result['status']) {
      if (type == 'init') {
        bangumiList.clear();
      } 
      bangumiList.addAll(result['data'].list);
      _currentPage += 1;
    } else {}
    isLoadingMore = false;
    return result;
  }
}