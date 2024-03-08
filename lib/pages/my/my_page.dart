import 'package:bilineo/pages/my/my_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/card/network_img_layer.dart';
import 'package:provider/provider.dart';
import 'package:bilineo/pages/menu/menu.dart';
import 'package:bilineo/bean/settings/settings.dart';
import 'package:bilineo/utils/storage.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _mineController = Modular.get<MyController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在widget构建完成后调用的函数
      final navigationBarState =
          Provider.of<NavigationBarState>(context, listen: false);
      if (navigationBarState.isHide == true) {
        navigationBarState.showNavigate();
      }
    });
  }

  void onBackPressed(BuildContext context) {
    final navigationBarState = Provider.of<NavigationBarState>(context, listen: false);
    navigationBarState.showNavigate();
    navigationBarState.updateSelectedIndex(0);
    Modular.to.navigate('/tab/popular/');
  }

  Widget get userInfoBuild {
    final navigationBarState = Provider.of<NavigationBarState>(context);
    return Observer(builder: (context) {
      return Column(children: [
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            navigationBarState.hideNavigate();
            _mineController.onLogin();
          },
          child: ClipOval(
            child: Container(
              width: 85,
              height: 85,
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: Center(
                child: _mineController.userFace != ''
                    ? NetworkImgLayer(
                        src: _mineController.userFace, width: 85, height: 85)
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
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('')),
        body: Column(
          children: [
            Center(
              child: userInfoBuild,
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '港澳台模式',
                subTitle: '实验性',
                setKey: SettingBoxKey.aeraUnlock,
                defaultVal: false,
              ),
            ),
            Observer(builder: (context) {
              return _mineController.userLogin
                  ? ListTile(
                      onTap: () {
                        _mineController.loginOut();
                      },
                      dense: false,
                      title: const Text('退出登录'),
                    )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }
}
