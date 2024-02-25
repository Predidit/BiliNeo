import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/menu/menu.dart';


class IndexPage extends StatefulWidget {
  //const IndexPage({super.key});
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with  WidgetsBindingObserver {

  final PageController _page = PageController();

  /// 统一处理前后台改变
  void appListener(bool state) {
    if (state) {
      print("应用前台");
    } else {
      print("应用后台");
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Row(children: [
    //   AppDrawer(page: _page),
    //   Expanded(
    //     child: PageView.builder(
    //       controller: _page,
    //       itemCount: menu.size,
    //       onPageChanged: (i) => Modular.to.navigate("/tab${menu.getPath(i)}/"),
    //       itemBuilder: (_, __) => const RouterOutlet(),
    //     ),
    //   )
    // ]);
    return const BottomMenu();
  }
}
