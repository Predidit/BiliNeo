import 'package:mobx/mobx.dart';

part 'video_controller.g.dart';

class VideoController = _VideoController with _$VideoController;

abstract class _VideoController with Store {

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

  @action
  void init() {

  }

}