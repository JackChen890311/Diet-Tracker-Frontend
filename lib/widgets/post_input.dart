import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;
import 'package:diet_tracker/utils/user.dart';
import 'package:intl/intl.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/services/global_service.dart';
import 'package:diet_tracker/services/api.dart';


Future<dynamic> showAddPostDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return PostDialog(); // Don't add const here it will break
      },);
}

bool submitInputForm(formKey) {
    if (!formKey.currentState!.validate()) {
      print('The form is invalid.');
      return false;
    }
    else{
      print('The form is valid!');
      formKey.currentState?.save();
      return true;
    }
    
    // debug
    // formKey.currentState?.save();
    // return true;
}

class PostDialog extends StatefulWidget {
  const PostDialog({super.key});

  @override
  State<PostDialog> createState() => _PostDialogState();
}

class _PostDialogState extends State<PostDialog> {
  late int dropdownValue;
  final List<EntryBlock> _entryList = [];
  int get getDDValue => dropdownValue;
  final global = GlobalService();

  int sortComparisonByDate(EntryBlock a, EntryBlock b){
    return -a.entry.date!.compareTo(b.entry.date!);
  }

  Future<void> getEntries(User user) async{
    final Map<String, dynamic>entryListString = await ApiService().getEntriesOfUser(user);
    List<dynamic> response = jsonDecode(entryListString['body']);

    Entry emptyEntry = Entry(entryID: 0, user: User(account: '', userName: '', /*email: '',*/ password: ''), foodName: '', restoName: '', price: 0, calories: 0, date: DateTime.now());
    _entryList.add(EntryBlock(entry: emptyEntry, imgFirst: true));

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
    // for (var entryBlock in _entryList) {
    //   print(entryBlock.getEntry.entryID);
    // }
    
  }

  @override
  void initState() {
    super.initState();
    // var firstEntry = _entryList[0].getEntry;
    // dropdownValue = firstEntry.entryID;
    
    // print('Init');
    // print(_entryList.length);
    // print(dropdownValue);
    // for (var entryBlock in _entryList) {
    //   print(entryBlock.getEntry.entryID);
    // }
    dropdownValue = 0;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var description = '';
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final User user = global.getUserData;
    _entryList.clear();

    return FutureBuilder(
      future: getEntries(user),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // print('Build');
          // for (var entryBlock in _entryList) {
          //   print(entryBlock.getEntry.entryID);
          // }
          _entryList.sort(sortComparisonByDate);
          return AlertDialog(
            title: const CustomText(
              label: 'Please enter a new post (You need to have entries to add a post):', color: CustomColor.darkBlue,
              type: 'titleLarge', align: 'left',),
            content: SizedBox(
              width: size.width * 0.8,
              height: size.height * 0.6,
              child: Column(
                children: [
                  Column(
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
                              items: _entryList.map<DropdownMenuItem<int>>((EntryBlock entryBlock) {
                                var entry = entryBlock.getEntry;
                                return DropdownMenuItem<int>(
                                  value: entry.entryID,
                                  child: entry.entryID == 0 ? const Text('Please select an entry') :
                                  Text('${DateFormat('yyyy-MM-dd').format(entry.date!)} : ${entry.foodName} @ ${entry.restoName}'),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.text_snippet),
                            SizedBox(width: size.width * 0.025),
                            SizedBox(width: size.width * 0.3, child: 
                              TextFormField(
                                // keyboardType: TextInputType.multiline,
                                // maxLines: null,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'Say something about the food!',
                                ),
                                onSaved: (value) => description = value!,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                            )
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  // entryList[entryList.indexWhere((entryBlock) => entryBlock.getEntry.entryID == dropdownValue)],
                  dropdownValue == 0 ? const SizedBox(width: 0,) :
                  EntryBlock(entry: _entryList[_entryList.indexWhere((entryBlock) => entryBlock.getEntry.entryID == dropdownValue)].getEntry, imgFirst: true,)
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const CustomText(label: 'Cancel'),
                onPressed: () {
                  User emptyUser = User(account: '', userName: '', /*email: '',*/ password: '');
                  Entry emptyEntry = Entry(entryID: 0, user: emptyUser);
                  Post emptyPost = Post(postID: 0, user: emptyUser, entry: emptyEntry);
                  Navigator.pop(context, emptyPost);
                },
              ),
              TextButton(
                child: const CustomText(label: 'Done'),
                onPressed: () {
                  var check = submitInputForm(formKey);
                  if (check) {
                    int entryId = _entryList.indexWhere((entryBlock) => entryBlock.getEntry.entryID == dropdownValue);
                    Post newPost = Post(
                      postID: DateTime.now().millisecondsSinceEpoch,
                      description: description,
                      entry: _entryList[entryId].getEntry,
                      user: _entryList[entryId].getUser,
                      like: [],
                      likeCnt: 0,
                      comment: [],
                      commentCnt: 0,);
                    // TODO: send new post to db
                    Navigator.pop(context, newPost);
                  }
                },
              ),
            ],
          );
        }
      }
    );
  }
}