import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:fl_chart/fl_chart.dart';

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


List<FlSpot> getSpots(List<double> values) {
  List<FlSpot> spots = [];
  for (int i = 0; i < values.length; i++) {
    spots.add(FlSpot(i.toDouble() + 1, values[i]));
  }
  return spots;
}

class MyLineChart extends StatelessWidget{
  const MyLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots1 = getSpots([100, 700, 300, 600, 500]);
    List<FlSpot> spots2 = getSpots([500, 800, 500, 400, 100]);

    return LineChart(
      LineChartData(
        minX: 1,
        maxX: 5,
        minY: 0,
        maxY: 1000,
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
