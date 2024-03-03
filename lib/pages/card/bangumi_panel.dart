import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bilineo/bean/bangumi/bangumi_info.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/my/user_info.dart';

class BangumiPanel extends StatefulWidget {
  const BangumiPanel({
    super.key,
    required this.pages,
    this.cid,
    this.sheetHeight,
    this.changeFuc,
  });

  final List<EpisodeItem> pages;
  final int? cid;
  final double? sheetHeight;
  final Function? changeFuc;

  @override
  State<BangumiPanel> createState() => _BangumiPanelState();
}

class _BangumiPanelState extends State<BangumiPanel> {
  int currentIndex = 0;
  // 默认未开通
  int vipStatus = 0;
  // Box userInfoCache = GStorage.userInfo;
  // dynamic userInfo;
  final ScrollController listViewScrollCtr = ScrollController();
  final userInfo = Modular.get<UserInfoData>();

  // @override
  // void initState() {
  //   super.initState();
  //   userInfo = userInfoCache.get('userInfoCache');
  //   if (userInfo != null) {
  //     vipStatus = userInfo.vipStatus;
  //   }
  // }

  // Todo 大会员相关
  void changeFucCall(item, i) async {
    // userInfo = userInfoCache.get('userInfoCache');
    // if (userInfo != null) {
    //   vipStatus = userInfo.vipStatus;
    // }
    debugPrint('校验大会员中, 当前用户 ${userInfo.uname}');
    if (item.badge != null && item.badge == '会员' && userInfo.vipStatus != 1) {
      SmartDialog.showToast('需要大会员');
      return;
    }
    await widget.changeFuc!(
      item.bvid,
      item.cid,
    );
    currentIndex = i;
    setState(() {});
    // scrollToIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('合集 '),
              Expanded(
                child: Text(
                  ' 正在播放：${widget.pages[currentIndex].longTitle}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 34,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),

                  // Todo 展示更多
                  onPressed: () => {},
                  child: Text(
                    '全${widget.pages.length}话',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Platform.isWindows ? 200 : 400,
          child: GridView.builder( 
            controller: listViewScrollCtr,
            scrollDirection: Axis.vertical, // 将滚动方向改为竖直
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Platform.isWindows ? 10 : 3,
              crossAxisSpacing: 10, // 间距
              mainAxisSpacing: 5, // 间距
              childAspectRatio: 1.7, // 子项宽高比
            ),
            itemCount: widget.pages.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                // width: 150,
                margin: const EdgeInsets.only(bottom: 10), // 改为bottom间距
                child: Material(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.circular(6),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () => changeFucCall(widget.pages[i], i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              if (i == currentIndex) ...<Widget>[
                                Image.asset(
                                  'assets/images/live.png',
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 12,
                                ),
                                const SizedBox(width: 6)
                              ],
                              Text(
                                '第${i + 1}话',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: i == currentIndex
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ),
                              const SizedBox(width: 2),
                              if (widget.pages[i].badge != null) ...[
                                if (widget.pages[i].badge == '会员') ...[
                                  Image.asset(
                                    'assets/images/big-vip.png',
                                    height: 16,
                                  ),
                                ],
                                if (widget.pages[i].badge != '会员') ...[
                                  const Spacer(),
                                  Text(
                                    widget.pages[i].badge!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ]
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.pages[i].longTitle!,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 13,
                                color: i == currentIndex
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
