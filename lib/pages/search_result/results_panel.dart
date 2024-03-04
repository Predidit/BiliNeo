import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/utils/constans.dart';
import 'package:bilineo/pages/card/pbadge.dart';
import 'package:bilineo/pages/card/network_img_layer.dart';
import 'package:bilineo/request/search.dart';
import 'package:bilineo/bean/bangumi/bangumi_info.dart';
import 'package:bilineo/pages/player/search_type.dart';
import 'package:bilineo/utils/utils.dart';
import 'package:bilineo/pages/video/video_controller.dart';
import 'package:provider/provider.dart';
import 'package:bilineo/pages/menu/menu.dart';

Widget searchMbangumiPanel(BuildContext context, ctr, list) {
  final VideoController videoController = Modular.get<VideoController>();
  TextStyle style =
      TextStyle(fontSize: Theme.of(context).textTheme.labelMedium!.fontSize);
  return ListView.builder(
    controller: ctr!.scrollController,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: false,
    itemCount: list!.length,
    itemBuilder: (context, index) {
      var i = list![index];
      return InkWell(
        onTap: () {
          /// TODO 番剧详情页面
          // Get.toNamed('/video?bvid=${i.bvid}&cid=${i.cid}', arguments: {
          //   'videoItem': i,
          //   'heroTag': Utils.makeHeroTag(i.id),
          //   'videoType': SearchType.media_bangumi
          // });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              StyleString.safeSpace, 7, StyleString.safeSpace, 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  NetworkImgLayer(
                    width: 111,
                    height: 148,
                    src: i.cover,
                  ),
                  PBadge(
                    text: i.mediaType == 1 ? '番剧' : '国创',
                    top: 6.0,
                    right: 4.0,
                    bottom: null,
                    left: null,
                  )
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        children: [
                          for (var i in i.title) ...[
                            TextSpan(
                              text: i['text'],
                              style: TextStyle(
                                fontSize: MediaQuery.textScalerOf(context)
                                    .scale(Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .fontSize!),
                                fontWeight: FontWeight.bold,
                                color: i['type'] == 'em'
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('评分:${i.mediaScore['score'].toString()}',
                        style: style),
                    Row(
                      children: [
                        Text(i.areas, style: style),
                        const SizedBox(width: 3),
                        const Text('·'),
                        const SizedBox(width: 3),
                        Text(Utils.dateFormat(i.pubtime).toString(),
                            style: style),
                      ],
                    ),
                    Row(
                      children: [
                        Text(i.styles, style: style),
                        const SizedBox(width: 3),
                        const Text('·'),
                        const SizedBox(width: 3),
                        Text(i.indexShow, style: style),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () async {
                          final navigationBarState = Provider.of<NavigationBarState>(context, listen: false);
                          SmartDialog.showLoading(msg: '获取中...');
                          var res = await SearchHttp.bangumiInfo(
                              seasonId: i.seasonId);
                          SmartDialog.dismiss().then((value) {
                            if (res['status']) {
                              EpisodeItem episode = res['data'].episodes.first;
                              String bvid = episode.bvid!;
                              int cid = episode.cid!;
                              String pic = episode.cover!;
                              String heroTag = Utils.makeHeroTag(cid);
                              // Todo SessionID
                              videoController.bvid = bvid;
                              videoController.cid = cid;
                              videoController.pic = pic;
                              videoController.heroTag = heroTag;
                              videoController.videoType =
                                  SearchType.media_bangumi;
                              videoController.bangumiItem = res['data'];
                              navigationBarState.hideNavigate();
                              Modular.to.navigate('/tab/video/');
                            }
                          });
                        },
                        child: const Text('观看'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
