import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;

FlTitlesData get getTitlesData => const FlTitlesData(
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),

    bottomTitles: AxisTitles(
      axisNameSize: 20,
      axisNameWidget: CustomText(label: 'Days'),
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


// List<FlSpot> getSpots(List<int> values) {
//   List<FlSpot> spots = [];
//   for (int i = 0; i < values.length; i++) {
//     spots.add(FlSpot(i.toDouble() + 1, values[i].toDouble()));
//   }
//   return spots;
// }

List<FlSpot> getSpotsFromXY(List<int> x, List<int> y) {
  List<FlSpot> spots = [];
  for (int i = 0; i < x.length; i++) {
    spots.add(FlSpot(x[i].toDouble(), y[i].toDouble()));
  }
  return spots;
}

class MyLineChart extends StatefulWidget{
  const MyLineChart({super.key});

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  // List<FlSpot> spots1 = getSpots([100, 700, 300, 600, 500]);
  // List<FlSpot> spots2 = getSpots([500, 800, 500, 400, 100]);
  List<DateTime> date = fakedata.priceByDate.keys.toList();
  List<int> priceint = fakedata.priceByDate.values.toList();
  List<int> caloriesint = fakedata.caloriesByDate.values.toList();
  

  @override
  Widget build(BuildContext context) {
    List<int> dateint = date.map((date) => date.day).toList();
    
    double minXpos = dateint.reduce((value, element) => value < element ? value : element).toDouble();
    double maxXpos = dateint.reduce((value, element) => value > element ? value : element).toDouble();
    double minYpos1 = priceint.reduce((value, element) => value < element ? value : element).toDouble() / 1.5;
    double maxYpos1 = priceint.reduce((value, element) => value > element ? value : element).toDouble() * 1.5;
    double minYpos2 = caloriesint.reduce((value, element) => value < element ? value : element).toDouble() / 1.5;
    double maxYpos2 = caloriesint.reduce((value, element) => value > element ? value : element).toDouble() * 1.5;
    double minYpos = (minYpos1 < minYpos2) ? minYpos1 : minYpos2;
    double maxYpos = (maxYpos1 > maxYpos2) ? maxYpos1 : maxYpos2;

    List<FlSpot> spots1 = getSpotsFromXY(dateint, priceint);
    List<FlSpot> spots2 = getSpotsFromXY(dateint, caloriesint);

    // print(dateint);
    // print(priceint);
    // print(caloriesint);
    // print(minXpos);
    // print(maxXpos);
    // print(minYpos);
    // print(maxYpos);

    return LineChart(
      LineChartData(
        minX: minXpos,
        maxX: maxXpos,
        minY: minYpos,
        maxY: maxYpos,
        gridData: const FlGridData(show: false),
        titlesData: getTitlesData,
        lineBarsData: [
          LineChartBarData( 
            spots: spots1,
            isCurved: true,
            color: CustomColor.darkBlue,
            barWidth: 3,
          ),
          LineChartBarData(
            spots: spots2,
            isCurved: true,
            color: CustomColor.darkRed,
            barWidth: 3,
          ),
        ]
      )
    );
  }
}
