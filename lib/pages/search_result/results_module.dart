import 'package:bilineo/pages/search_result/results_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchResultModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const SearchResultPage());
  }
}
