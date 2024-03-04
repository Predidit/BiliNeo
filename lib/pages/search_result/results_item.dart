import 'package:flutter/material.dart';
import 'package:bilineo/pages/player/search_type.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/search_result/results_controller.dart';
import 'package:bilineo/pages/search/search_controller.dart';
import 'package:bilineo/pages/error/http_error.dart';
import 'package:bilineo/pages/search_result/results_panel.dart';

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

  final MySearchController mySearchController = Modular.get<MySearchController>();
  final SearchResultController searchResultController = Modular.get<SearchResultController>();

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
      child: Observer(
        builder: (context) {
          return FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  Map data = snapshot.data;
                  // var ctr = searchResultController;
                  List list = searchResultController.resultList;
                  if (data['status']) {
                    // return Obx(() {
                    //   switch (widget.searchType) {
                    //     case SearchType.video:
                    //       return SearchVideoPanel(
                    //         ctr: searchResultController,
                    //         // ignore: invalid_use_of_protected_member
                    //         list: list,
                    //       );
                    //     case SearchType.media_bangumi:
                    //       return searchMbangumiPanel(context, ctr, list);
                    //     case SearchType.bili_user:
                    //       return searchUserPanel(context, ctr, list);
                    //     case SearchType.live_room:
                    //       return searchLivePanel(context, ctr, list);
                    //     case SearchType.article:
                    //       return searchArticlePanel(context, ctr, list);
                    //     default:
                    //       return const SizedBox();
                    //   }
                    // });
                    return searchMbangumiPanel(context, searchResultController, list);
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
                return const CircularProgressIndicator();
              }
            },
          );
        }
      ),
    );
  }
}
