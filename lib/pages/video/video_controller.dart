import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:bilineo/pages/player/search_type.dart';
import 'package:bilineo/pages/player/player_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
}
