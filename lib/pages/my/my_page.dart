import 'package:bilineo/pages/my/my_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/card/network_img_layer.dart';
import 'package:provider/provider.dart';
import 'package:bilineo/pages/menu/menu.dart';
import 'package:bilineo/bean/settings/settings.dart';
import 'package:bilineo/utils/storage.dart';
import 'package:bilineo/request/api.dart';
import 'package:hive/hive.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Box setting = GStorage.setting;
  late dynamic defaultThemeMode;
  final _mineController = Modular.get<MyController>();

  @override
  void initState() {
    super.initState();
    defaultThemeMode =
        setting.get(SettingBoxKey.themeMode, defaultValue: 'system');
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
    final navigationBarState =
        Provider.of<NavigationBarState>(context, listen: false);
    navigationBarState.showNavigate();
    navigationBarState.updateSelectedIndex(0);
    Modular.to.navigate('/tab/popular/');
  }

  void updateTheme(String theme) async {
    if (theme == 'dark') {
      AdaptiveTheme.of(context).setDark();
    }
    if (theme == 'light') {
      AdaptiveTheme.of(context).setLight();
    }
    if (theme == 'system') {
      AdaptiveTheme.of(context).setSystem();
    }
    await setting.put(SettingBoxKey.themeMode, theme);
    setState(() {
      defaultThemeMode = theme;
    });
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
            InkWell(
              child: SetSwitchItem(
                title: '港澳台模式',
                subTitle: '实验性',
                setKey: SettingBoxKey.aeraUnlock,
                defaultVal: false,
                callFn: (_) => {_mineController.clearPopularCache()},
              ),
            ),
            ListTile(
              onTap: () {
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('主题模式'),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 2,
                              children: [
                                defaultThemeMode == 'system'
                                    ? FilledButton(
                                        onPressed: () {
                                          updateTheme('system');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("跟随系统"))
                                    : FilledButton.tonal(
                                        onPressed: () {
                                          updateTheme('system');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("跟随系统")),
                                defaultThemeMode == 'light'
                                    ? FilledButton(
                                        onPressed: () {
                                          updateTheme('light');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("浅色"))
                                    : FilledButton.tonal(
                                        onPressed: () {
                                          updateTheme('light');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("浅色")),
                                defaultThemeMode == 'dark'
                                    ? FilledButton(
                                        onPressed: () {
                                          updateTheme('dark');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("深色"))
                                    : FilledButton.tonal(
                                        onPressed: () {
                                          updateTheme('dark');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("深色")),
                              ],
                            );
                          },
                        ),
                      );
                    });
              },
              dense: false,
              title: const Text('主题模式'),
              subtitle: Text(
                  defaultThemeMode == 'light'
                      ? '浅色'
                      : (defaultThemeMode == 'dark' ? '深色' : '跟随系统'),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () {
                _mineController.checkUpdata();
              },
              dense: false,
              title: const Text('检查更新'),
              subtitle: Text('当前版本 ${Api.version}',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
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
