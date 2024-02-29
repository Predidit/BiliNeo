import 'package:bilineo/pages/my/my_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:bilineo/pages/my/my_controller.dart';

class MyModule extends Module {
  @override
  void binds(i) {
    // i.addSingleton(MyController.new);
  }

  @override
  void routes(r) {
    r.child("/", child: (_) => const MyPage());
  }
}
