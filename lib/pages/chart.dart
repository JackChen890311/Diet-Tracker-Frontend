import 'package:diet_tracker/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/app_bar.dart';
import 'package:diet_tracker/widgets/chart.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});
  final String title = 'Chart';

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const MyAppBar(title: 'Chart'),
      body: Center(
        child: Column(
          children: (size.height > 300)? [
            const CustomText(label: 'Diet Chart', type: 'displaySmall'), 
            SizedBox(height: size.height * 0.05),
            SizedBox(
              height: size.height * 0.4, 
              width: size.width * 0.9, 
              child: const MyLineChart()
            ),
          ] :
          [
            const CustomText(label: 'Please use a larger device', type: 'titleMedium'),
          ]
        )
      ),
    );
  }
}
