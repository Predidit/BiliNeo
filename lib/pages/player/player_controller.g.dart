// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayerController on _PlayerController, Store {
  late final _$bvidAtom =
      Atom(name: '_PlayerController.bvid', context: context);

  @override
  String get bvid {
    _$bvidAtom.reportRead();
    return super.bvid;
  }

  bool _bvidIsInitialized = false;

  @override
  set bvid(String value) {
    _$bvidAtom.reportWrite(value, _bvidIsInitialized ? super.bvid : null, () {
      super.bvid = value;
      _bvidIsInitialized = true;
    });
  }

  late final _$cidAtom = Atom(name: '_PlayerController.cid', context: context);

  @override
  int get cid {
    _$cidAtom.reportRead();
    return super.cid;
  }

  bool _cidIsInitialized = false;

  @override
  set cid(int value) {
    _$cidAtom.reportWrite(value, _cidIsInitialized ? super.cid : null, () {
      super.cid = value;
      _cidIsInitialized = true;
    });
  }

  late final _$seasonIdAtom =
      Atom(name: '_PlayerController.seasonId', context: context);

  @override
  int get seasonId {
    _$seasonIdAtom.reportRead();
    return super.seasonId;
  }

  bool _seasonIdIsInitialized = false;

  @override
  set seasonId(int value) {
    _$seasonIdAtom
        .reportWrite(value, _seasonIdIsInitialized ? super.seasonId : null, () {
      super.seasonId = value;
      _seasonIdIsInitialized = true;
    });
  }

  late final _$picAtom = Atom(name: '_PlayerController.pic', context: context);

  @override
  String get pic {
    _$picAtom.reportRead();
    return super.pic;
  }

  bool _picIsInitialized = false;

  @override
  set pic(String value) {
    _$picAtom.reportWrite(value, _picIsInitialized ? super.pic : null, () {
      super.pic = value;
      _picIsInitialized = true;
    });
  }

  late final _$heroTagAtom =
      Atom(name: '_PlayerController.heroTag', context: context);

  @override
  String get heroTag {
    _$heroTagAtom.reportRead();
    return super.heroTag;
  }

  bool _heroTagIsInitialized = false;

  @override
  set heroTag(String value) {
    _$heroTagAtom
        .reportWrite(value, _heroTagIsInitialized ? super.heroTag : null, () {
      super.heroTag = value;
      _heroTagIsInitialized = true;
    });
  }

  late final _$videoTypeAtom =
      Atom(name: '_PlayerController.videoType', context: context);

  @override
  dynamic get videoType {
    _$videoTypeAtom.reportRead();
    return super.videoType;
  }

  bool _videoTypeIsInitialized = false;

  @override
  set videoType(dynamic value) {
    _$videoTypeAtom.reportWrite(
        value, _videoTypeIsInitialized ? super.videoType : null, () {
      super.videoType = value;
      _videoTypeIsInitialized = true;
    });
  }

  late final _$bangumiItemAtom =
      Atom(name: '_PlayerController.bangumiItem', context: context);

  @override
  dynamic get bangumiItem {
    _$bangumiItemAtom.reportRead();
    return super.bangumiItem;
  }

  bool _bangumiItemIsInitialized = false;

  @override
  set bangumiItem(dynamic value) {
    _$bangumiItemAtom.reportWrite(
        value, _bangumiItemIsInitialized ? super.bangumiItem : null, () {
      super.bangumiItem = value;
      _bangumiItemIsInitialized = true;
    });
  }

  late final _$isShowCoverAtom =
      Atom(name: '_PlayerController.isShowCover', context: context);

  @override
  bool get isShowCover {
    _$isShowCoverAtom.reportRead();
    return super.isShowCover;
  }

  @override
  set isShowCover(bool value) {
    _$isShowCoverAtom.reportWrite(value, super.isShowCover, () {
      super.isShowCover = value;
    });
  }

  late final _$directionAtom =
      Atom(name: '_PlayerController.direction', context: context);

  @override
  String get direction {
    _$directionAtom.reportRead();
    return super.direction;
  }

  bool _directionIsInitialized = false;

  @override
  set direction(String value) {
    _$directionAtom.reportWrite(
        value, _directionIsInitialized ? super.direction : null, () {
      super.direction = value;
      _directionIsInitialized = true;
    });
  }

  late final _$dataStatusAtom =
      Atom(name: '_PlayerController.dataStatus', context: context);

  @override
  String get dataStatus {
    _$dataStatusAtom.reportRead();
    return super.dataStatus;
  }

  bool _dataStatusIsInitialized = false;

  @override
  set dataStatus(String value) {
    _$dataStatusAtom.reportWrite(
        value, _dataStatusIsInitialized ? super.dataStatus : null, () {
      super.dataStatus = value;
      _dataStatusIsInitialized = true;
    });
  }

  late final _$_PlayerControllerActionController =
      ActionController(name: '_PlayerController', context: context);

  @override
  void init() {
    final _$actionInfo = _$_PlayerControllerActionController.startAction(
        name: '_PlayerController.init');
    try {
      return super.init();
    } finally {
      _$_PlayerControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bvid: ${bvid},
cid: ${cid},
seasonId: ${seasonId},
pic: ${pic},
heroTag: ${heroTag},
videoType: ${videoType},
bangumiItem: ${bangumiItem},
isShowCover: ${isShowCover},
direction: ${direction},
dataStatus: ${dataStatus}
    ''';
  }
}
