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

  late final _$bangumiItemAtom =
      Atom(name: '_VideoController.bangumiItem', context: context);

  @override
  BangumiInfoModel? get bangumiItem {
    _$bangumiItemAtom.reportRead();
    return super.bangumiItem;
  }

  bool _bangumiItemIsInitialized = false;

  @override
  set bangumiItem(BangumiInfoModel? value) {
    _$bangumiItemAtom.reportWrite(
        value, _bangumiItemIsInitialized ? super.bangumiItem : null, () {
      super.bangumiItem = value;
      _bangumiItemIsInitialized = true;
    });
  }

  late final _$showPositionedAtom =
      Atom(name: '_VideoController.showPositioned', context: context);

  @override
  bool get showPositioned {
    _$showPositionedAtom.reportRead();
    return super.showPositioned;
  }

  @override
  set showPositioned(bool value) {
    _$showPositionedAtom.reportWrite(value, super.showPositioned, () {
      super.showPositioned = value;
    });
  }

  late final _$showPositionAtom =
      Atom(name: '_VideoController.showPosition', context: context);

  @override
  bool get showPosition {
    _$showPositionAtom.reportRead();
    return super.showPosition;
  }

  @override
  set showPosition(bool value) {
    _$showPositionAtom.reportWrite(value, super.showPosition, () {
      super.showPosition = value;
    });
  }

  late final _$showBrightnessAtom =
      Atom(name: '_VideoController.showBrightness', context: context);

  @override
  bool get showBrightness {
    _$showBrightnessAtom.reportRead();
    return super.showBrightness;
  }

  @override
  set showBrightness(bool value) {
    _$showBrightnessAtom.reportWrite(value, super.showBrightness, () {
      super.showBrightness = value;
    });
  }

  late final _$showVolumeAtom =
      Atom(name: '_VideoController.showVolume', context: context);

  @override
  bool get showVolume {
    _$showVolumeAtom.reportRead();
    return super.showVolume;
  }

  @override
  set showVolume(bool value) {
    _$showVolumeAtom.reportWrite(value, super.showVolume, () {
      super.showVolume = value;
    });
  }

  late final _$playingAtom =
      Atom(name: '_VideoController.playing', context: context);

  @override
  bool get playing {
    _$playingAtom.reportRead();
    return super.playing;
  }

  @override
  set playing(bool value) {
    _$playingAtom.reportWrite(value, super.playing, () {
      super.playing = value;
    });
  }

  late final _$isBufferingAtom =
      Atom(name: '_VideoController.isBuffering', context: context);

  @override
  bool get isBuffering {
    _$isBufferingAtom.reportRead();
    return super.isBuffering;
  }

  @override
  set isBuffering(bool value) {
    _$isBufferingAtom.reportWrite(value, super.isBuffering, () {
      super.isBuffering = value;
    });
  }

  late final _$currentPositionAtom =
      Atom(name: '_VideoController.currentPosition', context: context);

  @override
  Duration get currentPosition {
    _$currentPositionAtom.reportRead();
    return super.currentPosition;
  }

  @override
  set currentPosition(Duration value) {
    _$currentPositionAtom.reportWrite(value, super.currentPosition, () {
      super.currentPosition = value;
    });
  }

  late final _$bufferAtom =
      Atom(name: '_VideoController.buffer', context: context);

  @override
  Duration get buffer {
    _$bufferAtom.reportRead();
    return super.buffer;
  }

  @override
  set buffer(Duration value) {
    _$bufferAtom.reportWrite(value, super.buffer, () {
      super.buffer = value;
    });
  }

  late final _$durationAtom =
      Atom(name: '_VideoController.duration', context: context);

  @override
  Duration get duration {
    _$durationAtom.reportRead();
    return super.duration;
  }

  @override
  set duration(Duration value) {
    _$durationAtom.reportWrite(value, super.duration, () {
      super.duration = value;
    });
  }

  late final _$volumeAtom =
      Atom(name: '_VideoController.volume', context: context);

  @override
  double get volume {
    _$volumeAtom.reportRead();
    return super.volume;
  }

  @override
  set volume(double value) {
    _$volumeAtom.reportWrite(value, super.volume, () {
      super.volume = value;
    });
  }

  late final _$brightnessAtom =
      Atom(name: '_VideoController.brightness', context: context);

  @override
  double get brightness {
    _$brightnessAtom.reportRead();
    return super.brightness;
  }

  @override
  set brightness(double value) {
    _$brightnessAtom.reportWrite(value, super.brightness, () {
      super.brightness = value;
    });
  }

  late final _$playerSpeedAtom =
      Atom(name: '_VideoController.playerSpeed', context: context);

  @override
  double get playerSpeed {
    _$playerSpeedAtom.reportRead();
    return super.playerSpeed;
  }

  @override
  set playerSpeed(double value) {
    _$playerSpeedAtom.reportWrite(value, super.playerSpeed, () {
      super.playerSpeed = value;
    });
  }

  late final _$androidFullscreenAtom =
      Atom(name: '_VideoController.androidFullscreen', context: context);

  @override
  bool get androidFullscreen {
    _$androidFullscreenAtom.reportRead();
    return super.androidFullscreen;
  }

  @override
  set androidFullscreen(bool value) {
    _$androidFullscreenAtom.reportWrite(value, super.androidFullscreen, () {
      super.androidFullscreen = value;
    });
  }

  @override
  String toString() {
    return '''
bvid: ${bvid},
cid: ${cid},
pic: ${pic},
heroTag: ${heroTag},
videoType: ${videoType},
bangumiItem: ${bangumiItem},
showPositioned: ${showPositioned},
showPosition: ${showPosition},
showBrightness: ${showBrightness},
showVolume: ${showVolume},
playing: ${playing},
isBuffering: ${isBuffering},
currentPosition: ${currentPosition},
buffer: ${buffer},
duration: ${duration},
volume: ${volume},
brightness: ${brightness},
playerSpeed: ${playerSpeed},
androidFullscreen: ${androidFullscreen}
    ''';
  }
}
