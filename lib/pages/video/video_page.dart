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
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiliNeo Video Test Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigationBarState.showNavigate();
            Modular.to.navigate('/tab/popular');
            //Modular.to.pop();
          },
        ),
      ),
      // body: Column(children: <Widget>[
      //   FutureBuilder<String>(
      //     future: videoController.init(playerController),
      //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return Center(child: SizedBox(
      //               child: Center(
      //                 child: CircularProgressIndicator(),
      //               ),
      //               height: Platform.isWindows
      //                   ? MediaQuery.of(context).size.width * 9.0 / 32.0
      //                   : MediaQuery.of(context).size.width * 9.0 / 16.0,
      //               width: Platform.isWindows
      //                   ? MediaQuery.of(context).size.width / 2
      //                   : MediaQuery.of(context).size.width,
      //             ),);
      //       } else if (snapshot.hasError) {
      //         return Center(child: Text('发生错误: ${snapshot.error}'));
      //       } else {
      //         return const PlayerItem();
      //       }
      //     },
      //   ),

      //   // Todo
      //   BangumiPanel(
      //     // pages: bangumiItem != null
      //     //     ? bangumiItem!.episodes!
      //     //     : widget.bangumiDetail!.episodes!,
      //     pages: bangumiItem!.episodes!,
      //     cid: videoController.cid,
      //     sheetHeight: sheetHeight,
      //     changeFuc: (bvidS, cidS) =>
      //         videoController.changeSeasonOrbangu(bvidS, cidS, playerController),
      //   )
      // ]),

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
    );
  }
}
