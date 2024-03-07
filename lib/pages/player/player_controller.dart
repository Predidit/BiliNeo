import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:bilineo/request/video.dart';
import 'package:bilineo/pages/player/player_url.dart';
import 'package:bilineo/pages/player/play_quality.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:bilineo/pages/player/player_datasource.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:bilineo/utils/utils.dart';
import 'package:bilineo/utils/video.dart';
import 'package:bilineo/request/constants.dart';


part 'player_controller.g.dart';

class PlayerController = _PlayerController with _$PlayerController;

abstract class _PlayerController with Store {

  @observable
  String bvid = '';

  @observable
  late int cid;

  @observable
  late int seasonId;

  @observable
  late String pic;

  @observable
  late String heroTag;

  @observable
  late dynamic videoType;

  @observable
  late dynamic bangumiItem;

  //是否展示封面图
  @observable
  bool isShowCover = true;

  //全屏方向
  @observable
  late String direction;

  late PlayUrlModel data;
  late VideoItem firstVideo;
  late AudioItem firstAudio;
  late String videoUrl;
  late String audioUrl;
  late Duration defaultST;

  late Player mediaPlayer;

  @observable
  late VideoController videoController;

  bool autoPlay = true;
  bool enableHA = true;

  // CDN优化 (Todo)
  bool enableCDN = true;
  int cacheVideoQa = 0;
  String cacheDecode = VideoDecodeFormats.values.last.code;
  int cacheAudioQa = AudioQuality.hiRes.code;
  late VideoQuality currentVideoQa;
  late VideoDecodeFormats currentDecodeFormats;
  late AudioQuality currentAudioQa;

  // 当前播放器状态
  @observable
  late String dataStatus;

  // 资源类型 (Todo)
  // SearchType videoType = SearchType.media_bangumi;

  // 播放器尺寸
  late double width;
  late double height;

  PlaylistMode looping = PlaylistMode.none;

  @action
  Future init() async {
    // mediaPlayer = await createVideoController(dataSource, looping, enableHA, width, height);
    dataStatus = 'loading';
    try {
      mediaPlayer.dispose();
      debugPrint('找到逃掉的 player');
    } catch (e) {
      debugPrint('未找到已经存在的 player');
    }
    debugPrint('VideoURL开始初始化');
    await queryVideoUrl();
    await setDataSource(DataSource(
        // Todo
        videoSource: videoUrl,
        audioSource: audioUrl,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': HttpString.baseUrl
        },
      ),
      // 硬解
      enableHAS: enableHA,
      bvidS: bvid,
      cidS: cid,
      autoplayS: autoPlay,);
      debugPrint('正在播放的bv是 $bvid');
      debugPrint('正在播放的cid是 $cid');
      debugPrint('VideoURL初始化成功 ${videoUrl}');
      dataStatus = 'loaded';
  }

  void dispose() {
    try {
      mediaPlayer.dispose();
      debugPrint('捕获到一个逃掉的 player');
    } catch (e) {
      debugPrint('没有捕获到漏掉的 player');
    }
  }

  //初始化资源
  Future<void> setDataSource(
    DataSource dataSource, {
    bool autoplayS = true,
    // 默认不循环
    PlaylistMode loopingS = PlaylistMode.none,
    // 初始化播放位置
    Duration seekToS = Duration.zero,
    // 初始化播放速度
    double speedS = 1.0,
    // 硬件加速
    bool enableHAS = true,
    double? widthS,
    double? heightS,
    Duration? durationS,
    // 方向
    String? directionS,
    // 记录历史记录
    String bvidS = '',
    int cidS = 0,
    // 历史记录开关
    bool enableHeartS = true,
    // 是否首次加载
    bool isFirstTimeS = true,
  }) async {
    try {
      autoPlay = autoplayS;
      looping = loopingS;
      // 初始化视频倍速
      // _playbackSpeed.value = speed;
      // 初始化数据加载状态
      // 初始化全屏方向
      direction = directionS ?? 'horizontal';
      width = widthS ?? 600;
      height = heightS ?? 300;
      bvid = bvidS;
      cid = cidS;

      // if (mediaPlayer != null &&
      //     mediaPlayer!.state.playing) {
      //   mediaPlayer.pause();
      //   dataStatus = 'paused';
      //   debugPrint('播放暂停');
      // }
      // 配置Player 音轨、字幕等等
      mediaPlayer = await createVideoController(
          dataSource, looping, enableHA, width, height);
      // 获取视频时长 00:00
      
      // 记录播放时间以待下次播放 (Todo)

      // 数据加载完成
      debugPrint('视频加载完成');
    } catch (err) {
      dataStatus = 'error';
      print('检查点三错误:  $err');
    }
  }

  // 配置播放器
  Future<Player> createVideoController(
    DataSource dataSource,
    PlaylistMode looping,
    bool enableHA,
    double? width,
    double? height,
  ) async {
    mediaPlayer = 
        Player(
          configuration: PlayerConfiguration(
            // 默认缓存 5M 大小
            bufferSize:
                videoType == 'live' ? 32 * 1024 * 1024 : 5 * 1024 * 1024,   //panic
          ),
        );

    var pp = mediaPlayer.platform as NativePlayer;
    // 解除倍速限制
    await pp.setProperty("af", "scaletempo2=max-speed=8");
    //  音量不一致
    if (Platform.isAndroid) {
      await pp.setProperty("volume-max", "100");
      await pp.setProperty("ao", "audiotrack,opensles");
    }

    await mediaPlayer.setAudioTrack(
      AudioTrack.auto(),
    );

    // 音轨
    if (dataSource.audioSource != '' && dataSource.audioSource != null) {
      await pp.setProperty(
        'audio-files',
        UniversalPlatform.isWindows
            ? dataSource.audioSource!.replaceAll(';', '\\;')
            : dataSource.audioSource!.replaceAll(':', '\\:'),
      );
    } else {
      await pp.setProperty(
        'audio-files',
        '',
      );
    }

    // 字幕
    if (dataSource.subFiles != '' && dataSource.subFiles != null) {
      await pp.setProperty(
        'sub-files',
        UniversalPlatform.isWindows
            ? dataSource.subFiles!.replaceAll(';', '\\;')
            : dataSource.subFiles!.replaceAll(':', '\\:'),
      );
      await pp.setProperty("subs-with-matching-audio", "no");
      await pp.setProperty("sub-forced-only", "yes");
      await pp.setProperty("blend-subtitles", "video");
    }

    videoController = 
        VideoController(
          mediaPlayer,
          configuration: VideoControllerConfiguration(
            enableHardwareAcceleration: enableHA,
            androidAttachSurfaceAfterVideoParameters: false,
          ),
        );
    debugPrint('videoController 配置成功');

    mediaPlayer.setPlaylistMode(looping);

    if (dataSource.type == DataSourceType.asset) {
      final assetUrl = dataSource.videoSource!.startsWith("asset://")
          ? dataSource.videoSource!
          : "asset://${dataSource.videoSource!}";
      mediaPlayer.open(
        Media(assetUrl, httpHeaders: dataSource.httpHeaders),
        play: false,
      );
    }
    mediaPlayer.open(
      Media(dataSource.videoSource!, httpHeaders: dataSource.httpHeaders),
      play: false,
    );
    // 音轨
    // player.setAudioTrack(
    //   AudioTrack.uri(dataSource.audioSource!),
    // );

    return mediaPlayer;
  }

  //获得视频详细
  Future queryVideoUrl() async {
    var result = await VideoRequest.videoUrl(cid: cid, bvid: bvid);
    debugPrint('已从服务器得到响应');
    if (result['status']) {
      data = result['data'];
      debugPrint('响应合法');
      if (data.acceptDesc!.isNotEmpty && data.acceptDesc!.contains('试看')) {
        debugPrint('目标资源只能试看');
        SmartDialog.showToast(
          '该视频为专属视频，仅提供试看',
          displayTime: const Duration(seconds: 3),
        );
        videoUrl = data.durl!.first.url!; 
        audioUrl = '';
        defaultST = Duration.zero;
        firstVideo = VideoItem();
        // if (autoPlay) {
        //   init;
        //   isShowCover = false;
        // }
        return result;
      }
      debugPrint('视频非试看');
      final List<VideoItem> allVideosList = data.dash!.video!;
      debugPrint('获取视频列表正常');
      try {
        // 当前可播放的最高质量视频
        int currentHighVideoQa = allVideosList.first.quality!.code;
        debugPrint('当前可用最高画质为 ${currentHighVideoQa}');
        // 预设的画质为null，则当前可用的最高质量
        if (cacheVideoQa == 0) {
          debugPrint('预设画质为 Null');
          cacheVideoQa = currentHighVideoQa;
          debugPrint('画质已设置为当前最高质量');
        }
        //cacheVideoQa ??= currentHighVideoQa;
        int resVideoQa = currentHighVideoQa;
        if (cacheVideoQa! <= currentHighVideoQa) {
          debugPrint('预设画质低于当前最高');
          // 如果预设的画质低于当前最高
          final List<int> numbers = data.acceptQuality!
              .where((e) => e <= currentHighVideoQa)
              .toList();
          resVideoQa = Utils.findClosestNumber(cacheVideoQa!, numbers);
        }
        currentVideoQa = VideoQualityCode.fromCode(resVideoQa)!;

      debugPrint('检查点一');

        /// 取出符合当前画质的videoList
        final List<VideoItem> videosList =
            allVideosList.where((e) => e.quality!.code == resVideoQa).toList();

        /// 优先顺序 设置中指定解码格式 -> 当前可选的首个解码格式
        final List<FormatItem> supportFormats = data.supportFormats!;
        // 根据画质选编码格式
        final List supportDecodeFormats =
            supportFormats.firstWhere((e) => e.quality == resVideoQa).codecs!;
        // 默认从设置中取AVC
        currentDecodeFormats = VideoDecodeFormatsCode.fromString(cacheDecode)!;
        try {
          // 当前视频没有对应格式返回第一个
          bool flag = false;
          for (var i in supportDecodeFormats) {
            if (i.startsWith(currentDecodeFormats.code)) {
              flag = true;
            }
          }
          currentDecodeFormats = flag
              ? currentDecodeFormats
              : VideoDecodeFormatsCode.fromString(supportDecodeFormats.first)!;
        } catch (err) {
          SmartDialog.showToast('DecodeFormats error: $err');
        }

        debugPrint('检查点二');

        /// 取出符合当前解码格式的videoItem
        try {
          firstVideo = videosList.firstWhere(
              (e) => e.codecs!.startsWith(currentDecodeFormats.code));
        } catch (_) {
          firstVideo = videosList.first;
        }
        debugPrint('获取资源中，非试看');
        videoUrl = enableCDN
            ? VideoUtils.getCdnUrl(firstVideo) 
            : (firstVideo.backupUrl ?? firstVideo.baseUrl!);
      } catch (err) {
        debugPrint('获取第一个视频错误： $err');
        SmartDialog.showToast('firstVideo error: $err');
      }

      /// 优先顺序 设置中指定质量 -> 当前可选的最高质量
      late AudioItem? firstAudio;
      final List<AudioItem> audiosList = data.dash!.audio!;

      try {
        if (data.dash!.dolby?.audio?.isNotEmpty == true) {
          // 杜比
          audiosList.insert(0, data.dash!.dolby!.audio!.first);
        }

        if (data.dash!.flac?.audio != null) {
          // 无损
          audiosList.insert(0, data.dash!.flac!.audio!);
        }

        if (audiosList.isNotEmpty) {
          final List<int> numbers = audiosList.map((map) => map.id!).toList();
          int closestNumber = Utils.findClosestNumber(cacheAudioQa, numbers);
          if (!numbers.contains(cacheAudioQa) &&
              numbers.any((e) => e > cacheAudioQa)) {
            closestNumber = 30280;
          }
          firstAudio = audiosList.firstWhere((e) => e.id == closestNumber);
        } else {
          firstAudio = AudioItem();
        }
      } catch (err) {
        firstAudio = audiosList.isNotEmpty ? audiosList.first : AudioItem();
        SmartDialog.showToast('firstAudio error: $err');
      }

      audioUrl = enableCDN
          ? VideoUtils.getCdnUrl(firstAudio)
          : (firstAudio.backupUrl ?? firstAudio.baseUrl!);
      //
      if (firstAudio.id != null) {
        currentAudioQa = AudioQualityCode.fromCode(firstAudio.id!)!;
      }
      defaultST = Duration(milliseconds: data.lastPlayTime!);
      if (autoPlay) {
        init;
        isShowCover = false;
      }
    } else {
      if (result['code'] == -404) {
        isShowCover = false;
      }
      SmartDialog.showToast(result['msg'].toString());
    }
    return result;
  }

}