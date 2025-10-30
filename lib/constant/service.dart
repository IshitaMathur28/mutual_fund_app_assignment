import 'package:dio/dio.dart';
import 'package:mutual_fund_app/data/model/scheme_model.dart';
import 'package:mutual_fund_app/data/model/nav_entry.dart';
import 'package:mutual_fund_app/constant/api_path.dart';
import 'package:mutual_fund_app/constant/constant.dart';

class Service {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<List<Scheme>> fetchAllSchemes() async {
    final resp = await _dio.get(ApiConstants.allSchemes); //storing response
    if (resp.statusCode == 200) {
      final List data = resp.data as List; //returns json array as dart list
      return data
          .map((e) => Scheme.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw constantMessage.noSchema;
  }

  //fetching data for specific scheme
  Future<List<NavEntry>> fetchNavs(String schemeCode) async {
    final resp = await _dio.get(ApiConstants.navByCode(schemeCode));
    if (resp.statusCode == 200) {
      final Map s = resp.data as Map;
      final List data = s['data'] as List;
      final entries = data
          .map((e) => NavEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      entries.sort((a, b) => a.date.compareTo(b.date));
      return entries;
    }
    throw constantMessage.noNavs;
  }
}
