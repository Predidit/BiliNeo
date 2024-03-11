import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/router.dart';
import 'package:provider/provider.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});
  @override
  State<BottomMenu> createState() => _BottomMenu();
}

class NavigationBarState extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isHide = false;

  int get selectedIndex => _selectedIndex;
  bool get isHide => _isHide;

  void updateSelectedIndex(int pageIndex) {
    _selectedIndex = pageIndex;
    notifyListeners();
  }

  void hideNavigate() {
    _isHide = true;
    notifyListeners();
  }

  void showNavigate() {
    _isHide = false;
    notifyListeners();
  }
}

class _BottomMenu extends State<BottomMenu> {
  var selectedIndex = 0;
  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NavigationBarState(),
        child: Scaffold(
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _page,
              itemCount: menu.size,
              onPageChanged: (i) =>
                  Modular.to.navigate("/tab${menu.getPath(i)}/"),
              itemBuilder: (_, __) => const RouterOutlet(),
            ),
          ),
          bottomNavigationBar:
              Consumer<NavigationBarState>(builder: (context, state, child) {
            return state.isHide
                ? const SizedBox(height: 0)
                : NavigationBar(
                    destinations: const <Widget>[
                      NavigationDestination(
                        selectedIcon: Icon(Icons.home),
                        icon: Icon(Icons.home_outlined),
                        label: '推荐',
                      ),
                      NavigationDestination(
                        selectedIcon: Icon(Icons.search),
                        icon: Icon(Icons.search_outlined),
                        label: '搜索',
                      ),
                      // NavigationDestination(
                      //   selectedIcon: Icon(Icons.code_rounded),
                      //   icon: Icon(Icons.code_rounded),
                      //   label: '排行榜',
                      // ),
                      NavigationDestination(
                        selectedIcon: Icon(Icons.settings),
                        icon: Icon(Icons.settings_outlined),
                        label: '我的',
                      ),
                    ],
                    selectedIndex: state.selectedIndex,
                    onDestinationSelected: (int index) {
                      // setState(() {
                      //   selectedIndex = index;
                      // });
                      state.updateSelectedIndex(index);
                      switch (index) {
                        case 0:
                          {
                            Modular.to.navigate('/tab/popular/');
                          }
                          break;
                        case 1:
                          {
                            Modular.to.navigate('/tab/search/');
                          }
                          break;
                        // case 2:
                        //   {
                        //     Modular.to.navigate('/tab/rating/');
                        //   }
                        //   break;
                        case 2:
                          {
                            Modular.to.navigate('/tab/my/');
                          }
                          break;
                      }
                    },
                  );
          }),
        ));
  }
}
