import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/app_bar.dart';
import 'package:diet_tracker/widgets/food_card.dart';
import 'package:diet_tracker/widgets/entry_input.dart';
import 'package:diet_tracker/utils/style.dart';

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
  final List<Widget> _foodList = [];

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
    Map newEntry = await showAddEntryDialog(context);
    if (newEntry.isEmpty) {
      return;
    }
    else{
      setState(() {
        _foodList.add(
          EntryBlock(
            photo: 'assets/ramen.jpg',
            date: newEntry['date']?.isEmpty ? "null" : newEntry['date'],
            foodname: newEntry['foodname'].isEmpty ? "null" : newEntry['foodname'],
            place: newEntry['place']?.isEmpty ? null : newEntry['place'],
            price: newEntry['price']?.isEmpty ? null : int.parse(newEntry['price']),
            calories: newEntry['calories']?.isEmpty ? null : int.parse(newEntry['calories']),
          )
        );
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ..._foodList.isEmpty 
                  ? [Column(children:[
                        SizedBox(height: size.height * 0.3), 
                        const CustomText(label: "No entries yet.", 
                                    type: 'displaySmall',
                                  )]
                    )]
                  : _foodList,
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEntry,
        tooltip: 'Add New Entry',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
