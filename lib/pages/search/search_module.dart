import 'package:bilineo/pages/search/search_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const SearchPage());
  }
}
