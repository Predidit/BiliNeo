// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VideoController on _VideoController, Store {
  late final _$bvidAtom = Atom(name: '_VideoController.bvid', context: context);

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

  late final _$cidAtom = Atom(name: '_VideoController.cid', context: context);

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

  late final _$picAtom = Atom(name: '_VideoController.pic', context: context);

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
      Atom(name: '_VideoController.heroTag', context: context);

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
      Atom(name: '_VideoController.videoType', context: context);

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

  @override
  String toString() {
    return '''
bvid: ${bvid},
cid: ${cid},
pic: ${pic},
heroTag: ${heroTag},
videoType: ${videoType}
    ''';
  }
}
