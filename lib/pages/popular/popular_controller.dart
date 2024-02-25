import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:bilineo/request/bangumi.dart';
import 'package:bilineo/bean/bangumi/bangumi_list.dart';

class PopularController extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  List<BangumiListItemModel> bangumiList = [BangumiListItemModel()];

  List<String> _items = [];
  List<String> get items => _items;

  int _currentPage = 1;
  bool isLoadingMore = true;

  Future queryBangumiListFeed({type = 'init'}) async {
    if (type == 'init') {
      _currentPage = 1;
    }
    var result = await BangumiHttp.bangumiList(page: _currentPage);
    if (result['status']) {
      if (type == 'init') {
        bangumiList.value = result['data'].list;
      } else {
        bangumiList.addAll(result['data'].list);
      }
      _currentPage += 1;
    } else {}
    isLoadingMore = false;
    return result;
  }

  void addItem(String item) {
    _items.add(item);
    notifyListeners(); 
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners(); 
  }
}