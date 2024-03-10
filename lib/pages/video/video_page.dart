import 'dart:io';
import 'package:bilineo/pages/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/video/video_controller.dart';
import 'package:bilineo/pages/player/player_item.dart';
import 'package:provider/provider.dart';
import 'package:bilineo/pages/menu/menu.dart';
import 'package:bilineo/bean/bangumi/bangumi_info.dart';
import 'package:bilineo/pages/card/bangumi_panel.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<VideoPage> {
  // late final BangumiInfoModel? bangumiItem;
  final VideoController videoController = Modular.get<VideoController>();
  final PlayerController playerController = Modular.get<PlayerController>();

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  void onBackPressed(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      debugPrint('当前播放器全屏');
      try {
        playerController.exitFullScreen();
        Modular.to.pop(context);
        return;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    debugPrint('当前播放器非全屏');
    final navigationBarState = Provider.of<NavigationBarState>(context, listen: false);
    navigationBarState.showNavigate();
    navigationBarState.updateSelectedIndex(0);
    Modular.to.navigate('/tab/popular/');
  }

  @override
  Widget build(BuildContext context) {
    final bangumiItem = videoController.bangumiItem;
    final navigationBarState = Provider.of<NavigationBarState>(context);
    double sheetHeight = MediaQuery.sizeOf(context).height -
        MediaQuery.of(context).padding.top -
        MediaQuery.sizeOf(context).width * 9 / 16;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (playerController.bvid == '') {
      videoController.init(playerController);
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(videoController.bangumiItem!.seasonTitle ?? ''),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              navigationBarState.showNavigate();
              navigationBarState.updateSelectedIndex(0);
              Modular.to.navigate('/tab/popular/');
              //Modular.to.pop();
            },
          ),
        ),
        body: Observer(builder: (context) {
          return Column(
            children: [
              const PlayerItem(),
              BangumiPanel(
                // pages: bangumiItem != null
                //     ? bangumiItem!.episodes!
                //     : widget.bangumiDetail!.episodes!,
                pages: bangumiItem!.episodes!,
                cid: videoController.cid,
                sheetHeight: sheetHeight,
                changeFuc: (bvidS, cidS) => videoController.changeSeasonOrbangu(
                    bvidS, cidS, playerController),
              )
            ],
          );
        }),
      ),
    );
  }
}
