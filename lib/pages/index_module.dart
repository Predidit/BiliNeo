import 'package:bilineo/pages/index_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/router.dart';
import 'package:bilineo/pages/init_page.dart';
import 'package:flutter/material.dart';
import 'package:bilineo/pages/popular/popular_controller.dart';

class IndexModule extends Module {
  @override
  List<Module> get imports => menu.moduleList;

  @override
  void binds(i) {
    i.addSingleton(PopularController.new);
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
