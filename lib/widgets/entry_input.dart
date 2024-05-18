import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/entry.dart';

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

// Ref 1: https://stackoverflow.com/questions/56252856/how-to-pick-files-and-images-for-upload-with-flutter-web
// Ref 2: https://github.com/miguelpruivo/flutter_file_picker/issues/1131
class FileUploadButton extends StatefulWidget {
  FileUploadButton({super.key});
  final List<String> _filePaths = [];
  List<String> get filePath => _filePaths;

  @override
  State<FileUploadButton> createState() => _FileUploadButtonState();
}

class _FileUploadButtonState extends State<FileUploadButton> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(children: [
        ElevatedButton(
          child: const Text('Upload Images'),
          onPressed: () async {
            widget._filePaths.clear();
            var picked = await FilePicker.platform.pickFiles(
              allowMultiple: true, 
              type: FileType.custom,
              allowedExtensions: ['jpg', 'png']
            );
            if (picked != null) {
              setState(() {
                for (var file in picked.files) {
                  // print(file.name);
                  widget._filePaths.add(file.name);
                }
              });
            }
          },
        ),
        SizedBox(width: size.width * 0.025),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(label: widget._filePaths.isNotEmpty ? widget._filePaths[0] : ''),
            CustomText(label: widget._filePaths.isNotEmpty ? widget._filePaths.length > 1 ? widget._filePaths[1] : '' : 'No files selected'),
            CustomText(label: widget._filePaths.length == 3 ? widget._filePaths[2] : widget._filePaths.length > 2 ? '...' : ''),
          ]
        ),
    ]);
  }
}

// void handleUploadedFile(FilePickerResult? picked) {
//   if (picked != null) {
//     // Access the first picked file
//     var file = picked.files.first;
//     // Access the file name
//     var fileName = file.name;
//     // Access the file path
//     var filePath = file.path;
//     // Access the file bytes
//     var fileBytes = file.bytes;
//     // Access the file size
//     var fileSize = file.size;

//     // Do something with the uploaded file
//     // For example, you can save it to a specific location or upload it to a server
//     // ...
//   } else {
//     // No file was picked
//     // Handle this case accordingly
//     // ...
//   }
// }

Future<dynamic> showAddEntryDialog(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var date = '';
    var foodname = '';
    var restoName = '';
    var price = '';
    var calories = '';
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    FileUploadButton fileUploadButton = FileUploadButton();

    return showDialog(
      context: context,
      builder: (context) {
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
                        SizedBox(width: size.width * 0.75, child: fileUploadButton),
                      ]),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const CustomText(label: 'Cancel'),
              onPressed: () {
                Entry emptyEntry = Entry(entryID: 0);
                Navigator.pop(context, emptyEntry);
              },
            ),
            TextButton(
              child: const CustomText(label: 'Done'),
              onPressed: () {
                var check = submitInputForm(formKey);
                if (check) {
                  Entry newEntry = Entry(
                    entryID: DateTime.now().millisecondsSinceEpoch,
                    entryImage: fileUploadButton._filePaths.isEmpty ?
                      'assets/food_empty.png' :
                      'assets/${fileUploadButton._filePaths[0]}', // 'assets/ramen.jpg',
                    user: null, // TODO: add user
                    date: DateTime.parse(date),
                    foodName: foodname,
                    restoName: restoName,
                    price: int.parse(price),
                    calories: int.parse(calories),
                  );
                  // TODO: send new entry to db
                  Navigator.pop(context, newEntry);
                }
              },
            ),
          ],
        );
      },);
  }