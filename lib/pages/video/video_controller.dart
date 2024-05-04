import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:bilineo/pages/search/search_type.dart';
import 'package:bilineo/pages/player/player_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/bean/bangumi/bangumi_info.dart';

part 'video_controller.g.dart';

class VideoController = _VideoController with _$VideoController;

abstract class _VideoController with Store {
  @observable
  late String bvid;

  @observable
  late int cid;

  @observable
  late String pic;

  @observable
  late String heroTag;

  @observable
  late dynamic videoType;

  @observable
  late BangumiInfoModel? bangumiItem;

  String from = '/tab/popular/';

    // 界面管理
  @observable
  bool showPositioned = false;
  @observable
  bool showPosition = false;
  @observable
  bool showBrightness = false;
  @observable
  bool showVolume = false;

  @observable
  bool playing = false;
  @observable
  bool isBuffering = true;
  @observable
  Duration currentPosition = Duration.zero;
  @observable
  Duration buffer = Duration.zero;
  @observable
  Duration duration = Duration.zero;

  // 视频音量/亮度
  @observable
  double volume = 0;
  @observable
  double brightness = 0;

  // 播放器倍速
  @observable
  double playerSpeed = 1.0;

  // 弹幕开关
  @observable
  bool danmakuOn = false;

  // 安卓全屏状态
  @observable
  bool androidFullscreen = false;

  // final PlayerController playerController = Modular.get<PlayerController>();

  Future<String> init(PlayerController playerController) async {
    playerController.bvid = bvid;
    playerController.cid = cid;
    playerController.pic = pic;
    playerController.heroTag = heroTag;
    playerController.videoType = SearchType.media_bangumi;
    await playerController.init();
    debugPrint('PlayerContriller 初始化成功');
    return 'PlayerContriller Init Success';
  }

  // 修改分P或番剧分集
  Future changeSeasonOrbangu(bvidS, cidS, PlayerController playerController) async {
    // 重新获取视频资源
    bvid = bvidS;
    cid = cidS;
    playerController.bvid = bvidS;
    playerController.cid = cidS;
    await playerController.init();
    debugPrint('PlayController 重新初始化成功');
  }

  Future setPlaybackSpeed(double playerSpeed) async {
    final PlayerController playerController = Modular.get<PlayerController>();
    try {
      playerController.mediaPlayer.setRate(playerSpeed);
    } catch(e) {
      debugPrint(e.toString());
    }
    this.playerSpeed = playerSpeed;
  }
}
