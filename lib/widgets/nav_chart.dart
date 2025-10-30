import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mutual_fund_app/data/model/nav_entry.dart';
import 'dart:math';
import 'package:mutual_fund_app/theme/app_colors.dart';

class NavChart extends StatefulWidget {
  final List<NavEntry> navs;

  const NavChart({required this.navs, super.key});

  @override
  State<NavChart> createState() => _NavChartState();
}

class _NavChartState extends State<NavChart> {
  int range = 0;

  List<NavEntry> get all => widget.navs;

  List<String> get period => ['1Y', '3Y', '5Y'];

  List<NavEntry> get filtered {
    final years = range == 0 ? 1 : (range == 1 ? 3 : 5);
    final cutoff = DateTime.now().subtract(Duration(days: (365 * years)));
    final res = all
        .where((e) => e.date.isAfter(cutoff) || e.date.isAtSameMomentAs(cutoff))
        .toList();
    if (res.isEmpty) return all;
    res.sort((a, b) => a.date.compareTo(b.date));
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final data = filtered;
    if (data.isEmpty) {
      return const Center(child: Text('no data'));
    }
    final spots = <FlSpot>[]; //naventry to chart xy form
    for (var i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].nav));
    }

    //color logic
    final double start = data.first.nav;
    final double end = data.last.nav;
    final Color LineColor;
    if (end > start) {
      LineColor = AppColors.ProfitColor;
    } else if (end < start) {
      LineColor = AppColors.LossColor;
    } else {
      LineColor = AppColors.NeutralColor;
    }
    //fetching from list
    final minY = data.map((e) => e.nav).reduce(min);
    final maxY = data.map((e) => e.nav).reduce(max);
    final Yrange = maxY - minY;
    final padding = Yrange * 0.1;
    final flat = Yrange.abs() < 1e-6; //chekcing if diff is negligible
    //if flat add padding to make it visible
    final adjustedMinY = flat ? minY - 1 : minY - padding;
    final adjustedMaxY = flat ? maxY + 1 : maxY + padding;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(period.length, (index) {
            final Selected = index == range;
            return GestureDetector(
              onTap: () => setState(() => range = index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Selected ? AppColors.divider : Colors.transparent,
                    border: Border.all(color: AppColors.divider, width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    period[index],
                    style: TextStyle(
                      color: Selected ? Colors.white : AppColors.divider,
                      fontWeight: Selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LineChart(
              LineChartData(
                minY: adjustedMinY,
                maxY: adjustedMaxY,
                titlesData: FlTitlesData(
                  //hide right and top
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (data.length / 6).clamp(10, 80).toDouble(),
                      getTitlesWidget: (v, meta) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= data.length)
                          return const SizedBox();
                        final d = data[idx].date;
                        return Transform.translate(
                          offset: const Offset(0, 6.0),
                          child: Text(
                            DateFormat('yy').format(d),
                            style: const TextStyle(fontSize: 9),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 40,
                      showTitles: true,
                      getTitlesWidget: (v, meta) => Text(
                        v.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    dotData: const FlDotData(show: false),
                    color: LineColor,
                    barWidth: 1.5,
                  ),
                ],
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: AppColors.divider, width: 1),
                    bottom: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
