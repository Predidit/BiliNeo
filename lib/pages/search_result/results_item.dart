import 'package:flutter/material.dart';
import 'package:bilineo/pages/search/search_type.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/search_result/results_controller.dart';
import 'package:bilineo/pages/search/search_controller.dart';
import 'package:bilineo/pages/error/http_error.dart';
import 'package:bilineo/pages/video/video_controller.dart';
import 'package:bilineo/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:bilineo/pages/menu/menu.dart';
import 'package:bilineo/pages/card/pbadge.dart';
import 'package:bilineo/pages/card/network_img_layer.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:bilineo/request/search.dart';
import 'package:bilineo/bean/bangumi/bangumi_info.dart';
import 'package:bilineo/utils/constans.dart';

class SearchPanel extends StatefulWidget {
  final String? keyword;
  final SearchType? searchType;
  final String? tag;
  const SearchPanel(
      {required this.keyword, required this.searchType, this.tag, Key? key})
      : super(key: key);

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel>
    with AutomaticKeepAliveClientMixin {
  final MySearchController mySearchController =
      Modular.get<MySearchController>();
  final SearchResultController searchResultController =
      Modular.get<SearchResultController>();
  final VideoController videoController = Modular.get<VideoController>();
  

  late Future _futureBuilderFuture;
  late ScrollController scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // _searchPanelController = Get.put(
    //   SearchPanelController(
    //     keyword: widget.keyword,
    //     searchType: widget.searchType,
    //   ),
    //   tag: widget.searchType!.type + widget.keyword!,
    // );
    searchResultController.searchKeyWord = mySearchController.searchKeyWord;
    scrollController = searchResultController.scrollController;
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        // Todo 防抖
        searchResultController.onSearch(type: 'onLoad');
        ;
      }
    });
    _futureBuilderFuture = searchResultController.onSearch();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await searchResultController.onRefresh();
      },
      child: Observer(builder: (context) {
        return FutureBuilder(
          future: _futureBuilderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                Map data = snapshot.data;
                // var ctr = searchResultController;
                List list = searchResultController.resultList;
                if (data['status']) {
                  return searchMbangumiPanelNeo;
                } else {
                  return CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [
                      HttpError(
                        errMsg: data['msg'],
                        fn: () {
                          setState(() {
                            searchResultController.onSearch();
                          });
                        },
                      ),
                    ],
                  );
                }
              } else {
                return CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    HttpError(
                      errMsg: '没有相关数据',
                      fn: () {
                        setState(() {
                          searchResultController.onSearch();
                        });
                      },
                    ),
                  ],
                );
              }
            } else {
              // 骨架屏
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      }),
    );
  }

  Widget get searchMbangumiPanelNeo {
    TextStyle style =
        TextStyle(fontSize: Theme.of(context).textTheme.labelMedium!.fontSize);
    return ListView.builder(
      controller: searchResultController.scrollController,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemCount: searchResultController.resultList.length,
      itemBuilder: (context, index) {
        var i = searchResultController.resultList[index];
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
                            final navigationBarState =
                                Provider.of<NavigationBarState>(context,
                                    listen: false);
                            SmartDialog.showLoading(msg: '获取中...');
                            var res = await SearchHttp.bangumiInfo(
                                seasonId: i.seasonId);
                            SmartDialog.dismiss().then((value) {
                              if (res['status']) {
                                EpisodeItem episode =
                                    res['data'].episodes.first;
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
}
