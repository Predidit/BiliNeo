// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MySearchController on _MySearchController, Store {
  late final _$searchKeyWordAtom =
      Atom(name: '_MySearchController.searchKeyWord', context: context);

  @override
  String get searchKeyWord {
    _$searchKeyWordAtom.reportRead();
    return super.searchKeyWord;
  }

  @override
  set searchKeyWord(String value) {
    _$searchKeyWordAtom.reportWrite(value, super.searchKeyWord, () {
      super.searchKeyWord = value;
    });
  }

  late final _$searchSuggestListAtom =
      Atom(name: '_MySearchController.searchSuggestList', context: context);

  @override
  List<SearchSuggestItem> get searchSuggestList {
    _$searchSuggestListAtom.reportRead();
    return super.searchSuggestList;
  }

  @override
  set searchSuggestList(List<SearchSuggestItem> value) {
    _$searchSuggestListAtom.reportWrite(value, super.searchSuggestList, () {
      super.searchSuggestList = value;
    });
  }

  late final _$controllerAtom =
      Atom(name: '_MySearchController.controller', context: context);

  @override
  TextEditingController get controller {
    _$controllerAtom.reportRead();
    return super.controller;
  }

  @override
  set controller(TextEditingController value) {
    _$controllerAtom.reportWrite(value, super.controller, () {
      super.controller = value;
    });
  }

  @override
  String toString() {
    return '''
searchKeyWord: ${searchKeyWord},
searchSuggestList: ${searchSuggestList},
controller: ${controller}
    ''';
  }
}
