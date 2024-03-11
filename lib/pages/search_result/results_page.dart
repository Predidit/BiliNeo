import 'package:flutter/material.dart';
import 'package:bilineo/pages/search/search_type.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/search/search_controller.dart';
import 'package:bilineo/pages/search_result/results_item.dart';
import 'package:bilineo/pages/search_result/results_controller.dart';
import 'package:bilineo/pages/menu/menu.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  final MySearchController mySearchController =
      Modular.get<MySearchController>();

  final SearchResultController searchResultController = Modular.get<SearchResultController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // searchResultController.resultList = [];
    // searchResultController.searchKeyWord = '';
    // debugPrint('搜索缓存已经清空');
    super.dispose();
  }

  void onBackPressed(BuildContext context) {
    final navigationBarState = Provider.of<NavigationBarState>(context, listen: false);
    navigationBarState.showNavigate();
    navigationBarState.updateSelectedIndex(1);
    Modular.to.navigate('/tab/search/');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(mySearchController.searchKeyWord),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Modular.to.navigate('/tab/search/');
              //Modular.to.pop();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: SearchPanel(
              keyword: mySearchController.searchKeyWord,
              searchType: SearchType.media_bangumi,
              tag: DateTime.now().millisecondsSinceEpoch.toString(),
            )),
          ],
        ),
      ),
    );
  }
}
