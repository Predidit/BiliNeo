import 'package:bilineo/pages/rating/rating_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RatingModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const RatingPage());
  }
}
