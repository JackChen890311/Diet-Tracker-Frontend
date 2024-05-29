import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/image.dart';
import 'package:diet_tracker/services/global_service.dart';
import 'package:diet_tracker/services/api.dart';


Future<dynamic> showAddEntryDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const EntryDialog();
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


class EntryDialog extends StatefulWidget {
  const EntryDialog({super.key});
  // final List<EntryBlock> entryList;

  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  // Ref: https://stackoverflow.com/questions/52125575/setstate-clears-the-data-in-form-element-data-flutter
  var date = '';
  var foodname = '';
  var restoName = '';
  var price = '';
  var calories = '';
  var imgString64 = '';
  List<String> filePaths = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final global = GlobalService();
  final ctlr = TextEditingController();
  var _response = '';

  Future<void> askGemini(String imgString64) async{
    var response = await ApiService().askGemini(imgString64);
    var message = jsonDecode(response['body'])['message'];
    var messageList = message.split('\n');
    var calNum = messageList.last.trim();
    var message2 = messageList.sublist(0,messageList.length-1).join('\n').trim();
    print(response);
    // print(messageList);
    // print(calNum);
    // print(message2);
    setState(() {
      _response = response['statusCode'] == 200 ? message2 : 'Error';
      ctlr.text = '$calNum';
    });
    // if(response['statusCode'] == 200){
      // TODO:decode `message: text` and save it to `ctlr.text` & `_response`
      // ctlr.text = 
      // _response = 
      // if(_response=''){
      //    _response = 'No uploaded image';
      // }
    // }
    // else{
    //   _response = 'Error';
    // }
    // setState(() {
    //    _response = '100';
    //   ctlr.text = '100';
    // });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final User user = global.getUserData;
    print(_response);

    return AlertDialog(
          title: const CustomText(
            label: 'Please enter a new entry:', color: CustomColor.darkBlue,
            type: 'titleLarge', align: 'left',),
          content: SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.5,
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(children: [
                        const Icon(Icons.calendar_today),
                        SizedBox(width: size.width * 0.025),
                        SizedBox(width: size.width * 0.3, child: 
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              hintText: 'YYYY-MM-DD',
                            ),
                            validator: (value) {
                              // TODO: Use date picker instead of tryParse
                              if (DateTime.tryParse(value!) == null) {
                                return 'Please enter a valid date';
                              }
                              return null;
                            },
                            onSaved: (value) => date = value!,
                          ),
                        )
                      ]),
                      Row(
                        children: [
                          const Icon(Icons.fastfood),
                          SizedBox(width: size.width * 0.025),
                          SizedBox(width: size.width * 0.3, child: 
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Food Name',
                                hintText: 'e.g. Fried Chicken',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter food name';
                                }
                                return null;
                              },
                              onSaved: (value) => foodname = value!,
                            ),
                          ),
                          SizedBox(width: size.width * 0.025),
                          const Icon(Icons.location_on),
                          SizedBox(width: size.width * 0.025),
                          SizedBox(width: size.width * 0.3, child: 
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Restaurant Name',
                                hintText: 'e.g. KFC',
                              ),
                              onSaved: (value) => restoName = value!,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter restaurant name';
                                }
                                return null;
                              },
                            ),
                          )
                      ]),
                      Row(
                        children: [
                          const Icon(Icons.attach_money),
                          SizedBox(width: size.width * 0.025),
                          SizedBox(width: size.width * 0.3, child: 
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Price',
                                hintText: 'e.g. 100',
                              ),
                              onSaved: (value) => price = value!,
                              validator: (value) {
                                if (int.tryParse(value!) == null){
                                    return 'Please enter a valid price';
                                }
                                else{
                                  if (int.tryParse(value)! < 0){
                                    return 'Please enter a valid price';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: size.width * 0.025),
                          const Icon(Icons.local_fire_department),
                          SizedBox(width: size.width * 0.025),
                          SizedBox(width: size.width * 0.3, child: 
                            TextFormField(
                              controller: ctlr,
                              decoration: const InputDecoration(
                                labelText: 'Calories',
                                hintText: 'e.g. 500',
                              ),
                              onSaved: (value) => calories = value!,
                              validator: (value) {
                                if (int.tryParse(value!) == null){
                                    return 'Please enter a valid calories';
                                }
                                else{
                                  if (int.tryParse(value)! < 0){
                                    return 'Please enter a valid calories';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                      ]),
                      Row(children: [
                        const Icon(Icons.image),
                        SizedBox(width: size.width * 0.025, height: size.height * 0.1),
                        SizedBox(width: size.width * 0.75, child: 
                          Row(children: [
                            ElevatedButton(
                              child: const Text('Upload Images'),
                              onPressed: () async {
                                filePaths.clear();
                                var picked = await FilePicker.platform.pickFiles(
                                  // allowMultiple: true, 
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png']
                                );
                                if (picked != null) {
                                  setState(() {
                                    for (var file in picked.files) {
                                      // print(file.name);
                                      // print(file.bytes); //Uint8List
                                      imgString64 = base64String(file.bytes!);
                                      filePaths.add(file.name);
                                    }
                                  });
                                }
                              },
                            ),
                            SizedBox(width: size.width * 0.025),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(label: filePaths.isNotEmpty ? filePaths[0] : 'No files selected'),
                                // CustomText(label: filePaths.isNotEmpty ? filePaths[0] : ''),
                                // CustomText(label: filePaths.isNotEmpty ? filePaths.length > 1 ? filePaths[1] : '' : 'No files selected'),
                                // CustomText(label: filePaths.length == 3 ? filePaths[2] : filePaths.length > 2 ? '...' : ''),
                              ]
                            ),
                        ])
                        ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.tips_and_updates),
                          SizedBox(width: size.width * 0.025),
                          ElevatedButton(
                            onPressed: (){
                              setState(() {
                                _response = 'Waiting...';
                              });
                              askGemini(filePaths.isEmpty ?'' : imgString64);
                            }, 
                            child: const Text('Click here to estimate calories')
                          ),
                          SizedBox(width: size.width * 0.025),
                          _response == '' ? const Text('') :            
                          SizedBox(width: size.width * 0.4, child: SingleChildScrollView(child: Text(_response))),
                        ]),
                        ]
                      )

                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const CustomText(label: 'Cancel'),
              onPressed: () {
                User emptyUser = User(account: '', userName: '', /*email: '',*/ password: '');
                Entry emptyEntry = Entry(entryID: 0, user: emptyUser);
                Navigator.pop(context, emptyEntry);
              },
            ),
            TextButton(
              child: const CustomText(label: 'Done'),
              onPressed: () {
                var check = submitInputForm(formKey);
                if (check) {
                  // print(imgString64);
                  Entry newEntry = Entry(
                    entryID: DateTime.now().millisecondsSinceEpoch,
                    entryImage: filePaths.isEmpty ?
                      '' : imgString64,
                      // 'assets/food_empty.png' :
                      //'assets/${filePaths[0]}', // 'assets/ramen.jpg',
                    user: user,
                    date: DateTime.parse(date),
                    foodName: foodname,
                    restoName: restoName,
                    price: int.parse(price),
                    calories: int.parse(calories),
                  );
                  Navigator.pop(context, newEntry);
                }
              },
            ),
          ],
        );

  }
}