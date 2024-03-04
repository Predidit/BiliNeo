import 'package:bilineo/pages/search/search_suggest.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:bilineo/pages/search/search_controller.dart';
import 'package:bilineo/request/search.dart';

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
        searchSuggestList = result['data'].tag;
      }
    }
  }

  void submit() {
    // ignore: unrelated_type_equality_checks
    if (searchKeyWord == '') {
      return;
    }
    debugPrint('Todo 搜索结果');
  }
}
