import 'package:get/get.dart';
import 'package:mutual_fund_app/constant/constant.dart';
import 'package:mutual_fund_app/data/model/scheme_model.dart';
import 'package:mutual_fund_app/constant/service.dart';
import 'package:mutual_fund_app/utils/storage.dart';

class SchemeController extends GetxController {
  final Service _service = Service();

  final schemes = <Scheme>[].obs;
  final filtered = <Scheme>[].obs;
  final loading = false.obs;
  final error = RxnString();

  @override
  void onInit() async {
    super.onInit();
    loading.value = true;
    try {
      final stored = Storage.readStorageKey;
      if (stored != null) {
        final List arr = stored as List;
        schemes.value = arr
            .map((e) => Scheme.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        filtered.assignAll(schemes);
        //delay
        await Future.delayed(const Duration(seconds: 3));
        loading.value = false;

        // refresh in background
        refreshFromApi();
      } else {
        final fetched = await _service.fetchAllSchemes();
        schemes.assignAll(fetched);
        filtered.assignAll(fetched);

        Storage.writeStorageKey = fetched.map((e) => e.toJson()).toList();

        // //delay
        await Future.delayed(const Duration(seconds: 2));
        loading.value = false;
      }
    } catch (e) {
      loading.value = false;

      error.value = e.toString();
    }
  }

  Future<void> refreshFromApi() async {
    try {
      final fetched = await _service.fetchAllSchemes();
      if (fetched.length != schemes.length) {
        schemes.assignAll(fetched);
        filtered.assignAll(fetched);
        Storage.writeStorageKey = fetched.map((e) => e.toJson()).toList();
      }
    } catch (_) {}
  }

  void search(String q) {
    final t = q.trim().toLowerCase();
    if (t.isEmpty) {
      filtered.assignAll(schemes);
      return;
    }
    final byName = schemes.where((s) => s.schemeName.toLowerCase().contains(t));
    final byCode = schemes.where((s) => s.schemeCode.toLowerCase().contains(t));
    final merged = {...byName, ...byCode}.toList();
    filtered.assignAll(merged);
  }
}
