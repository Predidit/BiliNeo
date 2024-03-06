import 'package:flutter/material.dart';
import 'package:bilineo/pages/player/search_type.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/search/search_controller.dart';
import 'package:bilineo/pages/search_result/results_item.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  final MySearchController mySearchController =
      Modular.get<MySearchController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
