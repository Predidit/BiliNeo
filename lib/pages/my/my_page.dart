import 'package:bilineo/pages/my/my_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/card/network_img_layer.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _mineController = Modular.get<MyController>();

  Widget get userInfoBuild {
    return Observer(
      builder: (context) {
        return Column(children: [
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => _mineController.onLogin(),
            child: ClipOval(
              child: Container(
                width: 85,
                height: 85,
                color: Theme.of(context).colorScheme.onInverseSurface,
                child: Center(
                  child: _mineController.userFace != ''
                      ? NetworkImgLayer(
                          src: _mineController.userFace,
                          width: 85,
                          height: 85)
                      : Image.asset('assets/images/noface.jpeg'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _mineController.uname == '' ? '点击头像登录' : _mineController.uname,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 4),
              Image.asset(
                'assets/images/lv/lv${_mineController.currentLevel}.png',
                height: 10,
              ),
            ],
          ),
        ]);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(title: const Text('BiliNeo My Test Page')),
      body: Center(
        child: userInfoBuild,
      ),
    );
  }
}
