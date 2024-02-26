import 'package:mobx/mobx.dart';
import 'package:bilineo/request/video.dart';
import 'package:bilineo/pages/player/player_url.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';


part 'player_controller.g.dart';

class PlayerController = _PlayerController with _$PlayerController;

abstract class _PlayerController with Store {

  @observable
  late String bvid;

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

  late PlayUrlModel data;
  late VideoItem firstVideo;
  late AudioItem firstAudio;
  late String videoUrl;
  late String audioUrl;
  late Duration defaultST;

  late final player = Player();
  late final videoController = VideoController(player) ;

  bool autoPlay = true;

  @action
  void init() {

  }

  Future queryVideoUrl() async {
    var result = await VideoRequest.videoUrl(cid: cid, bvid: bvid);
    if (result['status']) {
      data = result['data'];
      if (data.acceptDesc!.isNotEmpty && data.acceptDesc!.contains('试看')) {
        SmartDialog.showToast(
          '该视频为专属视频，仅提供试看',
          displayTime: const Duration(seconds: 3),
        );
        videoUrl = data.durl!.first.url!; 
        audioUrl = '';
        defaultST = Duration.zero;
        firstVideo = VideoItem();
        if (autoPlay.value) {
          await playerInit();
          isShowCover.value = false;
        }
        return result;
      }
      final List<VideoItem> allVideosList = data.dash!.video!;
      try {
        // 当前可播放的最高质量视频
        int currentHighVideoQa = allVideosList.first.quality!.code;
        // 预设的画质为null，则当前可用的最高质量
        cacheVideoQa ??= currentHighVideoQa;
        int resVideoQa = currentHighVideoQa;
        if (cacheVideoQa! <= currentHighVideoQa) {
          // 如果预设的画质低于当前最高
          final List<int> numbers = data.acceptQuality!
              .where((e) => e <= currentHighVideoQa)
              .toList();
          resVideoQa = Utils.findClosestNumber(cacheVideoQa!, numbers);
        }
        currentVideoQa = VideoQualityCode.fromCode(resVideoQa)!;

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

        /// 取出符合当前解码格式的videoItem
        try {
          firstVideo = videosList.firstWhere(
              (e) => e.codecs!.startsWith(currentDecodeFormats.code));
        } catch (_) {
          firstVideo = videosList.first;
        }
        videoUrl = enableCDN
            ? VideoUtils.getCdnUrl(firstVideo)
            : (firstVideo.backupUrl ?? firstVideo.baseUrl!);
      } catch (err) {
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
      if (autoPlay.value) {
        await playerInit();
        isShowCover.value = false;
      }
    } else {
      if (result['code'] == -404) {
        isShowCover.value = false;
      }
      SmartDialog.showToast(result['msg'].toString());
    }
    return result;
  }

}