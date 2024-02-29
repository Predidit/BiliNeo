// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webview_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WebviewController on _WebviewController, Store {
  late final _$typeAtom =
      Atom(name: '_WebviewController.type', context: context);

  @override
  String get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(String value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$loadProgressAtom =
      Atom(name: '_WebviewController.loadProgress', context: context);

  @override
  int get loadProgress {
    _$loadProgressAtom.reportRead();
    return super.loadProgress;
  }

  @override
  set loadProgress(int value) {
    _$loadProgressAtom.reportWrite(value, super.loadProgress, () {
      super.loadProgress = value;
    });
  }

  late final _$loadShowAtom =
      Atom(name: '_WebviewController.loadShow', context: context);

  @override
  bool get loadShow {
    _$loadShowAtom.reportRead();
    return super.loadShow;
  }

  @override
  set loadShow(bool value) {
    _$loadShowAtom.reportWrite(value, super.loadShow, () {
      super.loadShow = value;
    });
  }

  @override
  String toString() {
    return '''
type: ${type},
loadProgress: ${loadProgress},
loadShow: ${loadShow}
    ''';
  }
}
