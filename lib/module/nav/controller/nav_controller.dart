import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mutual_fund_app/data/model/nav_entry.dart';
import 'package:mutual_fund_app/constant/service.dart';
import 'package:mutual_fund_app/constant/constant.dart';

class NavController extends GetxController {
  final Service _service = Service(); //api
  final navs = <NavEntry>[].obs;
  final loading = false.obs;
  final error = RxnString();

  final Map<String, List<NavEntry>> _cache = {}; //in memory map for caching
  //function to load nav
  Future<void> loadNavs(String schemeCode) async {
    if (_cache.containsKey(schemeCode)) {
      navs.assignAll(_cache[schemeCode]!);
      return;
    }

    try {
      loading.value = true;
      EasyLoading.show(status: constantMessage.loadSchema);
      final data = await _service.fetchNavs(schemeCode);

      navs.assignAll(data); //update chart automatically
      _cache[schemeCode] = data; //updating cache too
    } catch (e) {
      error.value = e.toString();
      EasyLoading.showError(constantMessage.noNavs); //store error if any
    } finally {
      loading.value = false;
      EasyLoading.dismiss();
    }
  }

  String Change(double oldvalue, double newvalue) {
    if (oldvalue == 0) return '-';
    final change = ((newvalue - oldvalue) / oldvalue) * 100.0;
    return '${change.toStringAsFixed(2)}%'; //to show upto 2 decimal places
  }

  NavEntry? findclosestbefore(DateTime target) {
    NavEntry? candidate;
    for (final n in navs) {
      if (n.date.isAfter(target)) break;
      candidate = n;
    }
    return candidate;
  }

  //cal percent gain
  Map<String, String> gainsFor(DateTime asOf) {
    final result = <String, String>{};
    if (navs.isEmpty) return {'1y': '—', '3y': '—', '5y': '—'};
    final latest = navs.last;
    DateTime one = DateTime(asOf.year - 1, asOf.month, asOf.day);
    DateTime three = DateTime(asOf.year - 3, asOf.month, asOf.day);
    DateTime five = DateTime(asOf.year - 5, asOf.month, asOf.day);

    final n1 = findclosestbefore(one);
    final n2 = findclosestbefore(three);
    final n3 = findclosestbefore(five);

    result['1y'] = n1 == null ? '-' : Change(n1.nav, latest.nav);
    result['3y'] = n2 == null ? '-' : Change(n2.nav, latest.nav);
    result['5y'] = n3 == null ? '-' : Change(n3.nav, latest.nav);
    return result;
  }
}
