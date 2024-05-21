import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/app_bar.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/widgets/entry_input.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;
import 'package:diet_tracker/services/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = 'Diet Tracker';

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // final List<EntryBlock> _entryList = [];
  final List<EntryBlock> _entryList = fakedata.entryList;

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  List<double> calculateTotal(){
    double totalPrice = 0;
    double totalCalories = 0;
    for (var entryblock in _entryList){
      totalPrice += entryblock.getEntry.price!;
      totalCalories += entryblock.getEntry.calories!;
    }
    return [totalPrice, totalCalories];
  }

  List<double> calculateTotalToday(){
    double totalPrice = 0;
    double totalCalories = 0;
    for (var entryblock in _entryList){
      if (calculateDifference(entryblock.getEntry.date!) == 0){
        totalPrice += entryblock.getEntry.price!;
        totalCalories += entryblock.getEntry.calories!;
      }
    }
    return [totalPrice, totalCalories];
  }

  int sortComparisonByDate(EntryBlock a, EntryBlock b){
    return -a.entry.date!.compareTo(b.entry.date!);
  }

  // int _counter = 0;
  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }
  void _addNewEntry () async {
    Entry newEntry = await showAddEntryDialog(context);
    if (newEntry.entryID == 0) {
      return;
    }
    else{
      setState(() {
        _entryList.add(
          EntryBlock(entry: newEntry, imgFirst: _entryList.length.isEven)
        );
        _entryList.sort(sortComparisonByDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var size = MediaQuery.of(context).size;
    var total = calculateTotal();
    var totalToday = calculateTotalToday();
    _entryList.sort(sortComparisonByDate);
    var username = "Jack";
    // ApiService api = ApiService();
    // api.hello();

    return Scaffold(
      // appBar: AppBar(
      //   // TRY THIS: Try changing the color here to a specific color (to
      //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      //   // change color while the other colors stay the same.
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      appBar: const MyAppBar(title: 'Diet Tracker'),
      // body: Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: Column(
      //     // Column is also a layout widget. It takes a list of children and
      //     // arranges them vertically. By default, it sizes itself to fit its
      //     // children horizontally, and tries to be as tall as its parent.
      //     //
      //     // Column has various properties to control how it sizes itself and
      //     // how it positions its children. Here we use mainAxisAlignment to
      //     // center the children vertically; the main axis here is the vertical
      //     // axis because Columns are vertical (the cross axis would be
      //     // horizontal).
      //     //
      //     // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
      //     // action in the IDE, or press "p" in the console), to see the
      //     // wireframe for each widget.
      //     children: <Widget>[
      //       const SizedBox(height: 30),
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       const SizedBox(height: 30),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //     ],
      //   ),
      // ),
      body: 
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            SizedBox(height: size.height * 0.05),
            CircleAvatar(
              backgroundColor: Colors.black12,
              radius: size.height * 0.12,
              child: CircleAvatar(
                backgroundImage:const AssetImage('assets/headshot.png'),
                radius: size.height * 0.1,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            CustomText(label: "Welcome, $username!", type: 'displaySmall',),
            const SizedBox(height: 50),
            const CustomText(label: "Your Summaries", type: 'titleLarge',),
            const SizedBox(height: 20),
            CustomText(label: "Total Price: ${total[0]}", type: 'titleSmall',),
            const SizedBox(height: 20),
            CustomText(label: "Total Calories: ${total[1]}", type: 'titleSmall',),
            const SizedBox(height: 20),
            CustomText(label: "Total Price Today: ${totalToday[0]}", type: 'titleSmall',),
            const SizedBox(height: 20),
            CustomText(label: "Total Calories Today: ${totalToday[1]}", type: 'titleSmall',),
          ],
        ),
        _entryList.isEmpty ? 
          const Center(
            child: CustomText(label: "No entries yet.", 
                          type: 'displaySmall',)
            )
          :
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(child: 
              SizedBox(
                height: size.height * 0.9,
                width: size.width * 0.5,
                child: ListView.builder(
                  itemCount: _entryList.length,
                  itemBuilder: (context, index){
                    return _entryList[index];
                  }
                ),
              )
            )
          ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Image.asset('assets/images/illustration-3.png', height: size.height * 0.5),
        //   ],
        // )
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEntry,
        tooltip: 'Add New Entry',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
