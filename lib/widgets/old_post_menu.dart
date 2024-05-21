import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/entry_card.dart';

class EntryMenu extends StatefulWidget {
  const EntryMenu({super.key, required this.entryList});
  final List<EntryBlock> entryList;

  @override
  State<EntryMenu> createState() => _EntryMenuState();
}

class _EntryMenuState extends State<EntryMenu> {
  late int dropdownValue;
  int get getDDValue => dropdownValue;

  @override
  void initState() {
    super.initState();
    var firstEntry = widget.entryList[0].getEntry;
    dropdownValue = firstEntry.entryID;
    // dropdownValue = '${DateFormat('yyyy-MM-dd').format(firstEntry.date!)} : ${firstEntry.foodName} @ ${firstEntry.restoName} \$ ${firstEntry.price} # ${firstEntry.calories}';
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.fastfood),
            SizedBox(width: size.width * 0.025),
            SizedBox(width: size.width * 0.3, child: 
              DropdownButton<int>(
                isExpanded: true,
                value: dropdownValue,
                onChanged: (int? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: widget.entryList.map<DropdownMenuItem<int>>((EntryBlock entryBlock) {
                  var entry = entryBlock.getEntry;
                  return DropdownMenuItem<int>(
                    value: entry.entryID,
                    child: Text('${DateFormat('yyyy-MM-dd').format(entry.date!)} : ${entry.foodName} @ ${entry.restoName} \$ ${entry.price} # ${entry.calories}'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}