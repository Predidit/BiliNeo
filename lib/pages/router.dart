import 'package:bilineo/pages/my/my_module.dart';
import 'package:bilineo/pages/rating/rating_module.dart';
import 'package:bilineo/pages/popular/popular_module.dart';
import 'package:bilineo/pages/video/video_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
 
class MenuRouteItem {
  final String path;
  final Module module;

  const MenuRouteItem({
    required this.path,
    required this.module,
  });
}

class MenuRoute {
  final List<MenuRouteItem> menuList;

  const MenuRoute(this.menuList);

  int get size => menuList.length;

  List<Module> get moduleList {
    return menuList.map((e) => e.module).toList();
  }

  List<ModuleRoute> get routes {
    return menuList.map((e) => ModuleRoute(e.path, module: e.module)).toList();
  }

  getPath(int index) {
    return menuList[index].path;
  }
}

final MenuRoute menu = MenuRoute([
  MenuRouteItem(
    path: "/popular",
    module: PopularModule(),
  ),
  MenuRouteItem(
    path: "/rating",
    module: RatingModule(),
  ),
  MenuRouteItem(
    path: "/my",
    module: MyModule(),
  ),
  MenuRouteItem(
    path: "/video",
    module: VideoModule(),
  ),
]);
