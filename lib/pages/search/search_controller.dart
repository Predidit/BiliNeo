import 'package:bilineo/pages/search/search_suggest.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:bilineo/pages/search/search_controller.dart';
import 'package:bilineo/request/search.dart';
import 'package:bilineo/pages/search_result/results_controller.dart';

part 'search_controller.g.dart';

class MySearchController = _MySearchController with _$MySearchController;

abstract class _MySearchController with Store {
  @observable
  String searchKeyWord = '';

  @observable
  List<SearchSuggestItem> searchSuggestList = [SearchSuggestItem()];

  @observable
  TextEditingController controller = TextEditingController();

  void onChange(value) {
    searchKeyWord = value;
    debugPrint('搜索框内容变动，当前内容 $value');
    if (value == '') {
      searchSuggestList = [];
      return;
    }
    querySearchSuggest(value);
  }

  onSelect(word) {
    searchKeyWord = word;
    controller.text = word;
    submit();
  }

  Future querySearchSuggest(String value) async {
    var result = await SearchHttp.searchSuggest(term: value);
    if (result['status']) {
      if (result['data'] is SearchSuggestModel) {
        debugPrint('来自服务器的搜索建议响应 ${result['data'].tag}');
        searchSuggestList = result['data'].tag;
        // return searchSuggestList;
      }
    }
  }

  void onClickKeyword(String keyword) {
    searchKeyWord = keyword;
    controller.text = keyword;
    // 移动光标
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.value.text.length),
    );
    submit();
  }

  void submit() {
    // ignore: unrelated_type_equality_checks
    if (searchKeyWord == '') {
      return;
    }
    debugPrint('Todo 搜索结果 $searchKeyWord');
    // final MySearchController mySearchController =
    //     Modular.get<MySearchController>();
    // final SearchResultController searchResultController =
    //     Modular.get<SearchResultController>();
    // searchResultController.searchKeyWord = mySearchController.searchKeyWord;
    // searchResultController.onSearch();
    Modular.to.navigate('/tab/searchresult/');
  }
}
