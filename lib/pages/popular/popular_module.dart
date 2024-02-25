import 'package:bilineo/pages/popular/popular_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/popular/popular_controller.dart';

class PopularModule extends Module {
  @override
  void binds(i) {
    //i.addSingleton(PopularController.new);
  }

  @override
  void routes(r) {
    r.child("/", child: (_) => const PopularPage());
  }
}
