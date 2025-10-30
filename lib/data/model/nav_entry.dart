import 'package:intl/intl.dart';

class NavEntry {
  final DateTime date;
  final double nav;

  NavEntry({required this.date, required this.nav});

  factory NavEntry.fromJson(Map<String, dynamic> j) {
    final df = DateFormat('dd-MM-yyyy');
    return NavEntry(
      date: df.parse(j['date']),
      nav: double.tryParse(j['nav'].toString().replaceAll(',', '')) ?? 0.0,
    );
  }
}
