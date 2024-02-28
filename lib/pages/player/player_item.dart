import 'dart:io';

import 'package:bilineo/pages/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PlayerItem extends StatefulWidget {
  const PlayerItem({super.key});

  @override
  State<PlayerItem> createState() => _PlayerItemState();
}

class _PlayerItemState extends State<PlayerItem> {
  final PlayerController playerController = Modular.get<PlayerController>();

  @override
  void initState() {
    super.initState();
    // debugPrint('在小部件中初始化');
    // playerController.init;
  }

  @override
  void dispose() {
    //player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('播放器获取到的bv是 ${playerController.bvid}');
    return Column(
      children: [
        // const Text('Video Player Test'),
        Observer(builder: (context) {
          return SizedBox(
            width: Platform.isWindows
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width,
            height: Platform.isWindows
                ? MediaQuery.of(context).size.width * 9.0 / 32.0
                : MediaQuery.of(context).size.width * 9.0 / 16.0,
            child: playerController.dataStatus == 'loaded'
                ? Video(controller: playerController.videoController)
                : SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    height: Platform.isWindows
                        ? MediaQuery.of(context).size.width * 9.0 / 32.0
                        : MediaQuery.of(context).size.width * 9.0 / 16.0,
                    width: Platform.isWindows
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width,
                  ),
          );
        }),
      ],
    );
  }
}
