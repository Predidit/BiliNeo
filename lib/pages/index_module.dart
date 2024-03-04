import 'package:bilineo/pages/index_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/router.dart';
import 'package:bilineo/pages/init_page.dart';
import 'package:flutter/material.dart';
import 'package:bilineo/pages/popular/popular_controller.dart';
import 'package:bilineo/pages/video/video_controller.dart';
import 'package:bilineo/pages/my/my_controller.dart';
import 'package:bilineo/pages/my/user_info.dart';
import 'package:bilineo/pages/webview/webview_controller.dart';
import 'package:bilineo/pages/search/search_controller.dart';


class IndexModule extends Module {
  @override
  List<Module> get imports => menu.moduleList;

  @override
  void binds(i) {
    i.addSingleton(PopularController.new);
    i.addSingleton(VideoController.new);
    i.addSingleton(MyController.new);
    i.addSingleton(UserInfoData.new);
    i.addSingleton(WebviewController.new);
    i.addSingleton(MySearchController.new);
    // i.addSingleton(GStorage.new);
    // i.addSingleton(PlayerController.new);
  }

  @override
  void routes(r) {
    r.child("/",
        child: (_) => const InitPage(),
        children: [
          ChildRoute(
            "/error",
            child: (_) => Scaffold(
              appBar: AppBar (title: const Text("BiliNeo")),
              body: const Center(child: Text("初始化失败")),
            ),
          ),
        ],
        transition: TransitionType.noTransition);
    r.child("/tab", child: (_) {
      return const IndexPage();
    }, children: menu.routes, transition: TransitionType.noTransition);
  }
}
