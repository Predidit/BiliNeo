import 'package:bilineo/pages/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PlayerItem extends StatefulWidget {
  const PlayerItem({super.key});

  @override
  State<PlayerItem> createState() => _PlayerItemState();
}

class _PlayerItemState extends State<PlayerItem> {
  // late final player = Player();
  // late final playerController = VideoController(player) ;
  // late final controller = Modular.get<PlayerController>().mediaPlayer;
  late final videoController = Modular.get<PlayerController>().videoController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Video Player Test'),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          child: Video(controller: videoController),
        ),
      ],
    );
  }
} 