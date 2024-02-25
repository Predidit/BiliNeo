import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bilineo/pages/popular/popular_controller.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  @override
  Widget build(BuildContext context) {
    final PopularController popularController = Provider.of<PopularController>(context);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Modular RxList Test'),
    //   ),
    //   body: ListView.builder(
    //     itemCount: controller.items.length,
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //         title: Text(controller.items[index]),
    //         trailing: IconButton(
    //           icon: Icon(Icons.delete),
    //           onPressed: () {
    //             controller.removeItem(index);
    //           },
    //         ),
    //       );
    //     },
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       controller.addItem('Item ${controller.items.length + 1}');
    //     },
    //     child: Icon(Icons.add),
    //   ),
    // );
    return RefreshIndicator(
      onRefresh: () async {
        await popularController.queryBangumiListFeed();
      },
      child: CustomScrollView(
        controller: popularController.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '推荐',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                StyleString.safeSpace, 0, StyleString.safeSpace, 0),
            sliver: FutureBuilder(
              future: _futureBuilderFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map data = snapshot.data as Map;
                  if (data['status']) {
                    return Obx(() => contentGrid(
                        popularController, popularController.bangumiList));
                  } else {
                    return HttpError(
                      errMsg: data['msg'],
                      fn: () {
                        _futureBuilderFuture =
                            popularController.queryBangumiListFeed();
                      },
                    );
                  }
                } else {
                  return contentGrid(popularController, []);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
