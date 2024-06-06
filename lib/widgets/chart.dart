import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/services/api.dart';
import 'package:diet_tracker/services/global_service.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;
import 'package:quiver/time.dart';

// Ref: https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md
FlTitlesData get getTitlesData => const FlTitlesData(
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),

    bottomTitles: AxisTitles(
      axisNameSize: 20,
      axisNameWidget: CustomText(label: 'Date'),
      sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 50,
      )
    ),
    leftTitles: AxisTitles(
      axisNameSize: 20,
      axisNameWidget: CustomText(label: 'Values'),
      sideTitles: SideTitles(
        showTitles: true,
        interval: 200,
        reservedSize: 50,
      )
    )
  );

List<FlSpot> getSpotsFromXY(List<int> x, List<int> y) {
  List<FlSpot> spots = [];
  for (int i = 0; i < x.length; i++) {
    spots.add(FlSpot(x[i].toDouble(), y[i].toDouble()));
  }
  return spots;
}

class MyLineChart extends StatefulWidget{
  const MyLineChart({super.key, required this.yearid, required this.monthid});
  final int monthid;
  final int yearid;

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  // bool showPrice = true;
  // bool showCalories = true;
  // Map<DateTime, int> priceByDate = fakedata.priceByDate;
  // Map<DateTime, int> caloriesByDate = fakedata.caloriesByDate;

  List<int> dateint = List.generate(31, (i) => i+1);

  List<int> generateValue(int yearid, int monthid, List<int> keyDate, Map<DateTime, int>valueByDate){
    List<int> valueint = [];
    for (var d in keyDate){
      if (valueByDate.containsKey(DateTime(yearid, monthid, d)) && d <= daysInMonth(yearid, monthid)){
        valueint.add(valueByDate[DateTime(yearid, monthid, d)]!);
      }
      else{
        valueint.add(0);
      }
    }
    return valueint;
  }

  @override
  Widget build(BuildContext context) {
    final global = GlobalService();
    final List<EntryBlock> entryList = global.getEntryData;

    Map<DateTime, int> priceByDate = fakedata.sumPriceByDate(entryList);
    Map<DateTime, int> caloriesByDate = fakedata.sumCaloriesByDate(entryList);
    
    List<int> priceint = generateValue(widget.yearid, widget.monthid, dateint, priceByDate);
    List<int> caloriesint = generateValue(widget.yearid, widget.monthid, dateint, caloriesByDate);

    double maxYpos1 = priceint.reduce((value, element) => value > element ? value : element).toDouble() + 100;
    double maxYpos2 = caloriesint.reduce((value, element) => value > element ? value : element).toDouble() + 100;
    double maxYpos = (maxYpos1 > maxYpos2) ? maxYpos1 : maxYpos2;

    List<FlSpot> priceSpot = getSpotsFromXY(dateint, priceint);
    List<FlSpot> caloriesSpot = getSpotsFromXY(dateint, caloriesint);

    return LineChart(
      LineChartData(
        minX: 1,
        maxX: 31,
        minY: 0,
        maxY: maxYpos,
        gridData: const FlGridData(show: false),
        titlesData: getTitlesData,
        lineBarsData: [
          LineChartBarData( 
            // show: showPrice,
            spots: priceSpot,
            color: CustomColor.darkBlue,
            barWidth: 3,
          ),
          LineChartBarData(
            // show: showCalories,
            spots: caloriesSpot,
            color: CustomColor.darkRed,
            barWidth: 3,
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (LineBarSpot _) => CustomColor.grey,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                  bool first = false;
                                  return touchedBarSpots.map((barSpot) {
                                    if (first) {
                                      first = false;
                                      return LineTooltipItem(
                                        'Price: ${barSpot.y}', const TextStyle(fontWeight: FontWeight.bold, color: CustomColor.darkBlue)
                                      );
                                    }
                                    else{
                                      first = true;
                                      return LineTooltipItem(
                                          'Calories: ${barSpot.y}', const TextStyle(fontWeight: FontWeight.bold, color: CustomColor.darkRed)
                                      );
                                    }
                                  }).toList();
                                },
          )
        ),
      )
    );
  }
}
