import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;
import 'package:diet_tracker/widgets/post_menu.dart';

// TODO: Change data
final List<EntryBlock> entryList = fakedata.entryList;

Future<dynamic> showAddPostDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return PostDialog(entryList: entryList,);
      },);
  }