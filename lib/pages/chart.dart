import 'package:diet_tracker/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diet_tracker/widgets/app_bar.dart';
import 'package:diet_tracker/widgets/chart.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});
  final String title = 'Chart';

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {

  int _yearid = DateTime.now().year;
  int _monthid = DateTime.now().month;

  void _changeMonth(int i){
    setState(() {
      _monthid += i;
      if (_monthid > 12){
        _monthid = 1;
        _yearid += 1;
      } else if (_monthid < 1){
        _monthid = 12;
        _yearid -= 1;
      }
    });
  }
  Map<int, String> monthMap = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
  };

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const MyAppBar(title: 'Chart'),
      body: Center(
        child: Column(
          children: (size.height > 300)? [
            const CustomText(label: 'Diet Data Chart', type: 'displaySmall'), 
            SizedBox(height: size.height * 0.025),
            CustomText(label: 'Today: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}', type: 'titleMedium'),
            SizedBox(height: size.height * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              SizedBox(width: size.width * 0.2),
              Align(
                alignment: Alignment.bottomLeft, 
                child: FloatingActionButton(
                  heroTag: "prev",
                  shape: const CircleBorder(),
                  onPressed: () => _changeMonth(-1),
                  tooltip: 'Previous Month',
                  child: const Icon(Icons.chevron_left_outlined),
                  ),
              ),
              CustomText(label: '$_yearid / ${monthMap[_monthid]!}', type: 'titleMedium'),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: "next",
                  shape: const CircleBorder(),
                  onPressed: () => _changeMonth(1),
                  tooltip: 'Next Month',
                  child: const Icon(Icons.chevron_right_outlined),
                  ),
              ),
              SizedBox(width: size.width * 0.2),
              ],
            ),
            SizedBox(height: size.height * 0.025),
            SizedBox(
              height: size.height * 0.4, 
              width: size.width * 0.9, 
              child: MyLineChart(yearid: _yearid, monthid: _monthid)
            ),
            SizedBox(height: size.height * 0.025),
          ] :
          [
            const CustomText(label: 'Please use a larger device', type: 'titleMedium'),
          ]
        )
      ),
    );
  }
}
