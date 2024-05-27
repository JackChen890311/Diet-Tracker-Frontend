import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/app_bar.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/widgets/entry_input.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;
import 'package:diet_tracker/services/api.dart';
import 'package:diet_tracker/services/global_service.dart';
import 'package:diet_tracker/utils/user.dart';

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
  final List<EntryBlock> _entryList = [];
  // final List<EntryBlock> _entryList = fakedata.entryList;

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  Future<void> getEntries(User user) async{
    final Map<String, dynamic>entryListString = await ApiService().getEntriesOfUser(user.account);
    List<dynamic> response = jsonDecode(entryListString['body']);
    if (response.isEmpty){
      return;
    }

    for (var entry in response){
      _entryList.add(
        EntryBlock(entry: Entry.fromJson(entry), imgFirst: true)//_entryList.length.isEven)
      );
    }
    // print('Done');
    // print(_entryList.length);
  }

  List<double> calculateTotal(List<EntryBlock> entryList){
    double totalPrice = 0;
    double totalCalories = 0;
    for (var entryblock in entryList){
      totalPrice += entryblock.getEntry.price!;
      totalCalories += entryblock.getEntry.calories!;
    }
    return [totalPrice, totalCalories];
  }

  List<double> calculateTotalToday(List<EntryBlock> entryList){
    double totalPrice = 0;
    double totalCalories = 0;
    for (var entryblock in entryList){
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
      // setState(() {
      //   _entryList.add(
      //     EntryBlock(entry: newEntry, imgFirst: _entryList.length.isEven)
      //   );
      //   _entryList.sort(sortComparisonByDate);
      // });
      // To Database
      // print(newEntry.toJson());
      var result = await ApiService().createEntry(newEntry);
      // Test
      // Map<String, dynamic> result = {'statusCode': 201, 'body': ''};
      // print(result);

      if (result['statusCode'] == 201){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('新增成功'),
              content: const Text('紀錄新增成功！'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        print('<LOG> Entry added successfully');
      }
      else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('新增失敗'),
              content: const Text('紀錄新增失敗，請檢查網路狀態或再試一次！'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        print('<LOG> Failed to add entry');
      }

    }
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final global = GlobalService();
    final User user = global.getUserData;
    var decodedJson = user.toJson();
    var userImg = decodedJson['userImg'];
    var userGender = decodedJson['gender'];
    var username = decodedJson['userName'];

    return FutureBuilder(
      future: getEntries(user),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var total = calculateTotal(_entryList);
          var totalToday = calculateTotalToday(_entryList);
          _entryList.sort(sortComparisonByDate);

          return Scaffold(
            appBar: const MyAppBar(title: 'Diet Tracker'),
            body: Row(
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
                  backgroundImage: userImg==null? userGender==0? const AssetImage('assets/headshot_female.jpg'):const AssetImage('assets/headshot_male.jpg'): AssetImage(userImg),
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
                child: CustomText(label: "No entries yet.\n\nClick the button below to add a new entry.\n", 
                              type: 'displaySmall',),
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
            ),
          );
        }
      },
    );
  }
}