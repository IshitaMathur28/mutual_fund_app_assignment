import 'package:get/get.dart';
import 'package:mutual_fund_app/data/model/scheme_model.dart';
import 'package:mutual_fund_app/utils/storage.dart';

class FavoritesController extends GetxController {
  final favs = <Scheme>[].obs;

  @override
  void onInit() {
    super.onInit();
    final stored = Storage.readFavourites;
    if (stored != null) {
      final List arr = stored as List; //json to dart list if fav exists
      favs.assignAll(
        arr.map((e) => Scheme.fromJson(Map<String, dynamic>.from(e))).toList(),
      );
    }
  }

  void add(Scheme s) {
    if (!favs.any((e) => e.schemeCode == s.schemeCode)) {
      favs.add(s);
      _save();
    }
  }

  void remove(Scheme s) {
    favs.removeWhere((e) => e.schemeCode == s.schemeCode);
    _save();
  }

  bool contains(Scheme s) => favs.any((e) => e.schemeCode == s.schemeCode);

  void _save() =>
      Storage.writeFavourites = favs.map((e) => e.toJson()).toList();
}
