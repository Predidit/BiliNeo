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
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.08),
            width: 1,
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
        title: GestureDetector(
          onTap: () => Modular.to.navigate('/tab/search/'),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '${mySearchController.searchKeyWord}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              // child: Column(
              //   children: [
              //     for (var i in SearchType.values) ...{
              //       SearchPanel(
              //         keyword: mySearchController.searchKeyWord,
              //         searchType: i,
              //         tag: DateTime.now().millisecondsSinceEpoch.toString(),
              //       )
              //     }
              //   ],
              // ),
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
