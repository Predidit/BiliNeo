import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/popular/popular_controller.dart';
import 'package:bilineo/utils/constans.dart';
import 'package:bilineo/pages/error/http_error.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bilineo/pages/card/bangumi_card.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  final ScrollController scrollController = ScrollController();
  final PopularController popularController = Modular.get<PopularController>();

  @override
  void initState() {
    super.initState();
    debugPrint('Popular初始化成功');
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
        popularController.isLoadingMore = true;
        popularController.onLoad();
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {   
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await popularController.queryBangumiListFeed();
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '推荐',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  StyleString.safeSpace, 0, StyleString.safeSpace, 0),
              sliver: FutureBuilder(
                future: popularController.queryBangumiListFeed(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Observer(
                        builder: (_) => contentGrid(
                          popularController, 
                          popularController.bangumiList
                          )
                        );
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () {
                              popularController.queryBangumiListFeed();
                        },
                      );
                    }
                  } else {
                    return contentGrid(popularController, []);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentGrid(ctr, bangumiList) {
    int crossCount = Platform.isWindows ? 8 : 3;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 行间距
        mainAxisSpacing: StyleString.cardSpace - 2,
        // 列间距
        crossAxisSpacing: StyleString.cardSpace,
        // 列数
        crossAxisCount: crossCount,
        mainAxisExtent: MediaQuery.of(context).size.width / crossCount / 0.65 +
            MediaQuery.textScalerOf(context).scale(32.0),
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return bangumiList!.isNotEmpty
              ? BangumiCardV(bangumiItem: bangumiList[index])
              : null;
        },
        childCount: bangumiList!.isNotEmpty ? bangumiList!.length : 10,
      ),
    );
  }
}
