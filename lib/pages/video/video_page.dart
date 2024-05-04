import 'dart:io';
import 'dart:async';
import 'package:bilineo/pages/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/video/video_controller.dart';
import 'package:bilineo/pages/player/player_item.dart';
import 'package:provider/provider.dart';
import 'package:bilineo/pages/menu/menu.dart';
import 'package:bilineo/pages/card/bangumi_panel.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:window_manager/window_manager.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:ns_danmaku/ns_danmaku.dart';
import 'package:bilineo/pages/danmaku/controller.dart';
import 'package:bilineo/bean/danmaku/dm.pb.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<VideoPage> with WindowListener {
  // late final BangumiInfoModel? bangumiItem;
  Box setting = GStorage.setting;
  late DanmakuController danmakuController;
  late PlDanmakuController _plDanmakuController;
  final FocusNode _focusNode = FocusNode();
  final VideoController videoController = Modular.get<VideoController>();
  final PlayerController playerController = Modular.get<PlayerController>();

  Timer? hideTimer;
  Timer? playerTimer;
  int latestAddedPosition = -1;

  // 弹幕
  final _danmuKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    videoController.playerSpeed = 1.0;
    _plDanmakuController = PlDanmakuController(videoController.cid);
    if (playerController.bvid == '') {
      videoController.init(playerController).then((_) {
        playerTimer = getPlayerTimer();
      });
    }
  }

  @override
  void dispose() {
    try {
      playerTimer?.cancel();
    } catch (e) {
      debugPrint(e.toString());
    }
    playerController.dispose();
    super.dispose();
  }

  void _handleTap() {
    videoController.showPositioned = true;
    if (hideTimer != null) {
      hideTimer!.cancel();
    }

    hideTimer = Timer(const Duration(seconds: 4), () {
      videoController.showPositioned = false;
      hideTimer = null;
    });
  }

  void onBackPressed(BuildContext context) {
    if (videoController.androidFullscreen) {
      debugPrint('当前播放器全屏');
      try {
        playerController.exitFullScreen();
        videoController.androidFullscreen = false;
        return;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    debugPrint('当前播放器非全屏');
    final navigationBarState =
        Provider.of<NavigationBarState>(context, listen: false);
    navigationBarState.showNavigate();
    navigationBarState.updateSelectedIndex(0);
    Modular.to.navigate('/tab/popular/');
  }

  Future<void> setVolume(double value) async {
    try {
      FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.setVolume(value);
    } catch (_) {}
  }

  Future<void> raiseVolume(double value) async {
    try {
      FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.raiseVolume(value);
    } catch (_) {}
  }

  Future<void> lowerVolume(double value) async {
    try {
      FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.lowerVolume(value);
    } catch (_) {}
  }

  Future<void> setBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
    } catch (_) {}
  }

  // 选择倍速
  void showSetSpeedSheet() {
    final double currentSpeed = videoController.playerSpeed;
    final List<double> speedsList = [
      0.25,
      0.5,
      0.75,
      1.0,
      1.25,
      1.5,
      1.75,
      2.0
    ];
    SmartDialog.show(
        useAnimation: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('播放速度'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Wrap(
                spacing: 8,
                runSpacing: 2,
                children: [
                  for (final double i in speedsList) ...<Widget>[
                    if (i == currentSpeed) ...<Widget>[
                      FilledButton(
                        onPressed: () async {
                          await videoController.setPlaybackSpeed(i);
                          SmartDialog.dismiss();
                        },
                        child: Text(i.toString()),
                      ),
                    ] else ...[
                      FilledButton.tonal(
                        onPressed: () async {
                          await videoController.setPlaybackSpeed(i);
                          SmartDialog.dismiss();
                        },
                        child: Text(i.toString()),
                      ),
                    ]
                  ]
                ],
              );
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: Text(
                  '取消',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await videoController.setPlaybackSpeed(1.0);
                  SmartDialog.dismiss();
                },
                child: const Text('默认速度'),
              ),
            ],
          );
        });
  }

  getPlayerTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      videoController.playing = playerController.mediaPlayer.state.playing;
      videoController.isBuffering =
          playerController.mediaPlayer.state.buffering;
      videoController.currentPosition =
          playerController.mediaPlayer.state.position;
      videoController.buffer = playerController.mediaPlayer.state.buffer;
      videoController.duration = playerController.mediaPlayer.state.duration;

      if (videoController.danmakuOn && videoController.playing) {
        if (!_plDanmakuController.initiated) {
          _plDanmakuController.initiate(videoController.duration.inMilliseconds,
              videoController.currentPosition.inMilliseconds);
        }
        int currentPosition = videoController.currentPosition.inMilliseconds;
        currentPosition -= currentPosition % 100; //取整百的毫秒数

        if (currentPosition == latestAddedPosition) {
          return;
        }
        latestAddedPosition = currentPosition;

        List<DanmakuElem>? currentDanmakuList =
            _plDanmakuController.getCurrentDanmaku(currentPosition);

        if (currentDanmakuList != null) {
          danmakuController.addItems(currentDanmakuList
              .map((e) => DanmakuItem(
                    e.content,
                    time: e.progress,
                  ))
              .toList());
        }
      }

      windowManager.addListener(this);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bangumiItem = videoController.bangumiItem;
    final navigationBarState = Provider.of<NavigationBarState>(context);

    // 弹幕设置
    // bool _running = true;
    bool _border = setting.get(SettingBoxKey.danmakuBorder, defaultValue: true);
    double _opacity =
        setting.get(SettingBoxKey.danmakuOpacity, defaultValue: 1.0);
    double _duration = 8;
    double _fontSize = setting.get(SettingBoxKey.danmakuFontSize,
        defaultValue: (Platform.isIOS || Platform.isAndroid) ? 16.0 : 25.0);
    double danmakuArea =
        setting.get(SettingBoxKey.danmakuArea, defaultValue: 1.0);
    bool _hideTop = !setting.get(SettingBoxKey.danmakuTop, defaultValue: true);
    bool _hideBottom =
        !setting.get(SettingBoxKey.danmakuBottom, defaultValue: true);
    bool _hideScroll =
        !setting.get(SettingBoxKey.danmakuScroll, defaultValue: true);

    double sheetHeight = MediaQuery.sizeOf(context).height -
        MediaQuery.of(context).padding.top -
        MediaQuery.sizeOf(context).width * 9 / 16;
    return PopScope(
      // key: _key,
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: SafeArea(
        child: Scaffold(
          body: Observer(builder: (context) {
            return Column(
              children: [
                playerController.dataStatus != 'loaded'
                    ? SizedBox(
                        height: videoController.androidFullscreen
                            ? (MediaQuery.of(context).size.height)
                            : (MediaQuery.of(context).size.width *
                                9.0 /
                                (16.0)),
                        width: MediaQuery.of(context).size.width,
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : Container(
                        color: Colors.black,
                        child: MouseRegion(
                          onHover: (_) {
                            _handleTap();
                          },
                          child: SizedBox(
                            height: videoController.androidFullscreen
                                ? (MediaQuery.of(context).size.height)
                                : (MediaQuery.of(context).size.width *
                                    9.0 /
                                    (16.0)),
                            width: MediaQuery.of(context).size.width,
                            child:
                                Stack(alignment: Alignment.center, children: [
                              const Center(child: PlayerItem()),
                              videoController.isBuffering
                                  ? const Positioned.fill(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Container(),
                              GestureDetector(
                                onTap: () async {
                                  _handleTap;
                                  try {
                                    videoController.volume =
                                        await FlutterVolumeController
                                                .getVolume() ??
                                            videoController.volume;
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),

                              // 弹幕覆盖层
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: videoController.androidFullscreen
                                    ? MediaQuery.sizeOf(context).height *
                                        danmakuArea
                                    : (MediaQuery.sizeOf(context).width *
                                        9 /
                                        16 *
                                        danmakuArea),
                                child: DanmakuView(
                                  key: _danmuKey,
                                  createdController: (DanmakuController e) {
                                    danmakuController = e;
                                    playerController.danmakuController = e;
                                    debugPrint('弹幕控制器创建成功');
                                  },
                                  option: DanmakuOption(
                                    hideTop: _hideTop,
                                    hideScroll: _hideScroll,
                                    hideBottom: _hideBottom,
                                    opacity: _opacity,
                                    fontSize: _fontSize,
                                    duration: _duration,
                                    borderText: _border,
                                  ),
                                  statusChanged: (e) {},
                                ),
                              ),
                              // 倍速条
                              (videoController.showPositioned ||
                                      !playerController
                                          .mediaPlayer.state.playing)
                                  ? Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 45,
                                            height: 34,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.zero),
                                              ),
                                              onPressed: () =>
                                                  showSetSpeedSheet(),
                                              child: Text(
                                                '${videoController.playerSpeed}X',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),

                              // 播放器手势控制
                              Positioned.fill(
                                  left: 16,
                                  top: 25,
                                  right: 15,
                                  bottom: 15,
                                  child: GestureDetector(onHorizontalDragUpdate:
                                      (DragUpdateDetails details) {
                                    videoController.showPosition = true;
                                    if (playerTimer != null) {
                                      // debugPrint('检测到拖动, 定时器取消');
                                      playerTimer!.cancel();
                                    }
                                    playerController.pause();
                                    final double scale = 180000 /
                                        MediaQuery.sizeOf(context).width;
                                    videoController.currentPosition = Duration(
                                        milliseconds: videoController
                                                .currentPosition
                                                .inMilliseconds +
                                            (details.delta.dx * scale).round());
                                  }, onHorizontalDragEnd:
                                      (DragEndDetails details) {
                                    playerController
                                        .seek(videoController.currentPosition);
                                    playerController.play();
                                    playerTimer = getPlayerTimer();
                                    videoController.showPosition = false;
                                  }, onVerticalDragUpdate:
                                      (DragUpdateDetails details) async {
                                    final double totalWidth =
                                        MediaQuery.sizeOf(context).width;
                                    final double totalHeight =
                                        MediaQuery.sizeOf(context).height;
                                    final double tapPosition =
                                        details.localPosition.dx;
                                    final double sectionWidth = totalWidth / 2;
                                    final double delta = details.delta.dy;

                                    /// 非全屏时禁用
                                    if (!videoController.androidFullscreen) {
                                      return;
                                    }
                                    if (tapPosition < sectionWidth) {
                                      // 左边区域
                                      videoController.showBrightness = true;
                                      try {
                                        videoController.brightness =
                                            await ScreenBrightness().current;
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      }
                                      final double level = (totalHeight) * 3;
                                      final double brightness =
                                          videoController.brightness -
                                              delta / level;
                                      final double result =
                                          brightness.clamp(0.0, 1.0);
                                      setBrightness(result);
                                    } else {
                                      // 右边区域
                                      videoController.showVolume = true;
                                      final double level = (totalHeight) * 3;
                                      final double volume =
                                          videoController.volume -
                                              delta / level;
                                      final double result =
                                          volume.clamp(0.0, 1.0);
                                      setVolume(result);
                                      videoController.volume = result;
                                    }
                                  }, onVerticalDragEnd:
                                      (DragEndDetails details) {
                                    videoController.showBrightness = false;
                                    videoController.showVolume = false;
                                  })),

                              // 顶部进度条
                              Positioned(
                                  top: 25,
                                  width: 200,
                                  child: videoController.showPosition
                                      ? Wrap(
                                          alignment: WrapAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0), // 圆角
                                              ),
                                              child: Text(
                                                '${videoController.currentPosition.inMinutes}:${(videoController.currentPosition.inSeconds) % 60}/${videoController.duration.inMinutes}:${(videoController.duration.inSeconds) % 60}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container()),
                              // 亮度条
                              Positioned(
                                  top: 25,
                                  child: videoController.showBrightness
                                      ? Wrap(
                                          alignment: WrapAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // 圆角
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    const Icon(
                                                        Icons.brightness_7,
                                                        color: Colors.white),
                                                    Text(
                                                      ' ${(videoController.brightness * 100).toInt()} %',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        )
                                      : Container()),
                              // 音量条
                              Positioned(
                                  top: 25,
                                  child: videoController.showVolume
                                      ? Wrap(
                                          alignment: WrapAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // 圆角
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    const Icon(
                                                        Icons.volume_down,
                                                        color: Colors.white),
                                                    Text(
                                                      ' ${(videoController.volume * 100).toInt()}%',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        )
                                      : Container()),
                              (videoController.showPositioned ||
                                      !playerController
                                          .mediaPlayer.state.playing)
                                  ? Positioned(
                                      top: 0,
                                      left: 0,
                                      child: IconButton(
                                        color: Colors.white,
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () {
                                          if (videoController
                                                  .androidFullscreen ==
                                              true) {
                                            playerController.exitFullScreen();
                                            videoController.androidFullscreen =
                                                false;
                                            return;
                                          }
                                          navigationBarState.showNavigate();
                                          videoController.from ==
                                                  '/tab/popular/'
                                              ? navigationBarState
                                                  .updateSelectedIndex(0)
                                              : (videoController.from ==
                                                      '/tab/follow/'
                                                  ? navigationBarState
                                                      .updateSelectedIndex(2)
                                                  : navigationBarState
                                                      .updateSelectedIndex(1));
                                          Modular.to
                                              .navigate(videoController.from);
                                        },
                                      ),
                                    )
                                  : Container(),

                              // 自定义播放器底部组件
                              (videoController.showPositioned ||
                                      !playerController
                                          .mediaPlayer.state.playing)
                                  ? Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            color: Colors.white,
                                            icon: Icon(videoController.playing
                                                ? Icons.pause
                                                : Icons.play_arrow),
                                            onPressed: () {
                                              if (videoController.playing) {
                                                playerController.pause();
                                              } else {
                                                playerController.play();
                                              }
                                            },
                                          ),
                                          Expanded(
                                            child: ProgressBar(
                                              timeLabelLocation:
                                                  TimeLabelLocation.none,
                                              progress: videoController
                                                  .currentPosition,
                                              buffered: videoController.buffer,
                                              total: videoController.duration,
                                              onSeek: (duration) {
                                                playerController.seek(duration);
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            color: Colors.white,
                                            icon: Icon(videoController.danmakuOn
                                                ? Icons.comment
                                                : Icons.comments_disabled),
                                            onPressed: () {
                                              danmakuController.clear();
                                              videoController.danmakuOn =
                                                  !videoController.danmakuOn;
                                              debugPrint(
                                                  '弹幕开关变更为 ${videoController.danmakuOn}');
                                            },
                                          ),
                                          IconButton(
                                            color: Colors.white,
                                            icon: Icon(videoController
                                                    .androidFullscreen
                                                ? Icons.fullscreen
                                                : Icons.fullscreen_exit),
                                            onPressed: () {
                                              if (videoController
                                                  .androidFullscreen) {
                                                debugPrint('尝试退出全屏');
                                                playerController
                                                    .exitFullScreen();
                                              } else {
                                                debugPrint('尝试进入全屏');
                                                playerController
                                                    .enterFullScreen();
                                              }
                                              videoController
                                                      .androidFullscreen =
                                                  !videoController
                                                      .androidFullscreen;
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ]),
                          ),
                        ),
                      ),

                videoController.androidFullscreen
                    ? Container()
                    : BangumiPanel(
                        // pages: bangumiItem != null
                        //     ? bangumiItem!.episodes!
                        //     : widget.bangumiDetail!.episodes!,
                        pages: bangumiItem!.episodes!,
                        cid: videoController.cid,
                        sheetHeight: sheetHeight,
                        changeFuc: (bvidS, cidS) => videoController
                            .changeSeasonOrbangu(bvidS, cidS, playerController),
                      )
                // SizedBox(child: Text("${videoController.androidFullscreen}")),
              ],
            );
          }),
        ),
      ),
    );
  }
}
