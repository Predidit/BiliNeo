import 'package:bilineo/pages/video/video_page.dart';
import 'package:bilineo/pages/video/video_controller.dart';
import 'package:bilineo/pages/player/player_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VideoModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(VideoController.new);
    i.addSingleton(PlayerController.new);
  }

  @override
  void routes(r) {
    r.child("/", child: (_) => const VideoPage());
  }
}
