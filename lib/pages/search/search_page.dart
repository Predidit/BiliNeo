import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/search/search_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isDark = false;
  final MySearchController mySearchController =
      Modular.get<MySearchController>();
  late Iterable<Widget> _lastOptions = <Widget>[];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Observer(builder: (context) {
        String _searchingWithQuery = mySearchController.searchKeyWord;
        return Center(
          child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                debugPrint('搜索框点击事件');
                // Panic, maybe due to Focus
                controller.openView();
              },
              onChanged: (value) {
                setState(() {
                  debugPrint('检查点一,当前值为 $value');
                  // mySearchController.onChange(value);
                });
              },
              leading: const Icon(Icons.search),
            );
          }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) async {
            _searchingWithQuery = controller.text;
            if (_searchingWithQuery == '') {
              debugPrint('搜索框内容为空');
              return [];
            }

            debugPrint('提交到搜索建议API的搜索内容为 $_searchingWithQuery');
            await mySearchController.querySearchSuggest(_searchingWithQuery);

            if (_searchingWithQuery != controller.text) {
              return _lastOptions;
            }

            _lastOptions = List<ListTile>.generate(
                mySearchController.searchSuggestList.length, (int index) {
              return ListTile(
                title: mySearchController.searchSuggestList[index].textRich,
                onTap: () {
                  controller.text =
                      mySearchController.searchSuggestList[index].term ?? '';
                  mySearchController.onSelect(controller.text);
                },
              );
            });

            return _lastOptions;
          }),
        );
      }),
    );
  }
}
