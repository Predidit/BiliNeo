// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MyController on _MyController, Store {
  late final _$userLoginAtom =
      Atom(name: '_MyController.userLogin', context: context);

  @override
  bool get userLogin {
    _$userLoginAtom.reportRead();
    return super.userLogin;
  }

  @override
  set userLogin(bool value) {
    _$userLoginAtom.reportWrite(value, super.userLogin, () {
      super.userLogin = value;
    });
  }

  late final _$userFaceAtom =
      Atom(name: '_MyController.userFace', context: context);

  @override
  String get userFace {
    _$userFaceAtom.reportRead();
    return super.userFace;
  }

  @override
  set userFace(String value) {
    _$userFaceAtom.reportWrite(value, super.userFace, () {
      super.userFace = value;
    });
  }

  late final _$unameAtom = Atom(name: '_MyController.uname', context: context);

  @override
  String get uname {
    _$unameAtom.reportRead();
    return super.uname;
  }

  @override
  set uname(String value) {
    _$unameAtom.reportWrite(value, super.uname, () {
      super.uname = value;
    });
  }

  late final _$currentLevelAtom =
      Atom(name: '_MyController.currentLevel', context: context);

  @override
  int get currentLevel {
    _$currentLevelAtom.reportRead();
    return super.currentLevel;
  }

  @override
  set currentLevel(int value) {
    _$currentLevelAtom.reportWrite(value, super.currentLevel, () {
      super.currentLevel = value;
    });
  }

  @override
  String toString() {
    return '''
userLogin: ${userLogin},
userFace: ${userFace},
uname: ${uname},
currentLevel: ${currentLevel}
    ''';
  }
}
