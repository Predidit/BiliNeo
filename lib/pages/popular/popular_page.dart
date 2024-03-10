import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/popular/popular_controller.dart';
import 'package:bilineo/utils/constans.dart';
import 'package:bilineo/pages/error/http_error.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bilineo/pages/card/bangumi_card.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/services.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage>
    with AutomaticKeepAliveClientMixin {
  DateTime? _lastPressedAt;
  // double scrollOffset = 0.0;
  final ScrollController scrollController = ScrollController();
  final PopularController popularController = Modular.get<PopularController>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    debugPrint('Popular初始化成功');
    if (popularController.bangumiList.length < 5) {
      debugPrint('Popular缓存列表为空, 尝试重加载');
      popularController.scrollOffset = 0.0;
      popularController.queryBangumiListFeed();
    }
    scrollController.addListener(() {
      popularController.scrollOffset = scrollController.offset;
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          popularController.isLoadingMore == false) {
        popularController.isLoadingMore = true;
        popularController.onLoad();
      }
    });
    debugPrint('Popular监听器已添加');
  }

  @override
  void dispose() {
    // popularController.scrollOffset = scrollController.offset;
    scrollController.removeListener(() {});
    debugPrint('popular 模块已卸载, 监听器移除');
    super.dispose();
  }

  void onBackPressed(BuildContext context) {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 2)) {
      // 两次点击时间间隔超过2秒，重新记录时间戳
      _lastPressedAt = DateTime.now();
      SmartDialog.showToast("再按一次退出应用");
      return; 
    }
    SystemNavigator.pop(); // 退出应用
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var themedata = Theme.of(context);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      debugPrint('尝试恢复状态');
      scrollController.jumpTo(popularController.scrollOffset);
      debugPrint('Popular加载完成');
    });
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await popularController.queryBangumiListFeed();
          },
          child: Scaffold(
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 16),
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
                    sliver: Observer(builder: (context) {
                      return (popularController.bangumiList.length < 5)
                          ? HttpError(
                              errMsg: '加载推荐流错误',
                              fn: () {
                                popularController.queryBangumiListFeed();
                              },
                            )
                          : contentGrid(popularController.bangumiList);
                    })),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                scrollController.jumpTo(0.0);
                popularController.scrollOffset = 0.0;
              },
              child: const Icon(Icons.arrow_upward),
            ),
            backgroundColor: themedata.colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }

  Widget contentGrid(bangumiList) {
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
