// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchResultController on _SearchResultController, Store {
  late final _$searchKeyWordAtom =
      Atom(name: '_SearchResultController.searchKeyWord', context: context);

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

  late final _$pageAtom =
      Atom(name: '_SearchResultController.page', context: context);

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  late final _$resultListAtom =
      Atom(name: '_SearchResultController.resultList', context: context);

  @override
  List<dynamic> get resultList {
    _$resultListAtom.reportRead();
    return super.resultList;
  }

  @override
  set resultList(List<dynamic> value) {
    _$resultListAtom.reportWrite(value, super.resultList, () {
      super.resultList = value;
    });
  }

  @override
  String toString() {
    return '''
searchKeyWord: ${searchKeyWord},
page: ${page},
resultList: ${resultList}
    ''';
  }
}
