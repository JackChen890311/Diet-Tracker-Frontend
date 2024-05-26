import 'package:flutter/material.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/utils/fakedata_lib.dart' as fakedata;
import 'package:diet_tracker/utils/user.dart';
import 'package:intl/intl.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/utils/post.dart';

// TODO: Change data
final List<EntryBlock> entryList = fakedata.entryList;

Future<dynamic> showAddPostDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return PostDialog(entryList: entryList,);
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
  const PostDialog({super.key, required this.entryList});
  final List<EntryBlock> entryList;

  @override
  State<PostDialog> createState() => _PostDialogState();
}

class _PostDialogState extends State<PostDialog> {
  late int dropdownValue;
  int get getDDValue => dropdownValue;

  @override
  void initState() {
    super.initState();
    var firstEntry = widget.entryList[0].getEntry;
    dropdownValue = firstEntry.entryID;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var description = '';
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: const CustomText(
        label: 'Please enter a new post:', color: CustomColor.darkBlue,
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
                        items: widget.entryList.map<DropdownMenuItem<int>>((EntryBlock entryBlock) {
                          var entry = entryBlock.getEntry;
                          return DropdownMenuItem<int>(
                            value: entry.entryID,
                            child: Text('${DateFormat('yyyy-MM-dd').format(entry.date!)} : ${entry.foodName} @ ${entry.restoName}'),
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
            // widget.entryList[widget.entryList.indexWhere((entryBlock) => entryBlock.getEntry.entryID == dropdownValue)],
            EntryBlock(entry: widget.entryList[widget.entryList.indexWhere((entryBlock) => entryBlock.getEntry.entryID == dropdownValue)].getEntry, imgFirst: true,)
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
              int entryId = widget.entryList.indexWhere((entryBlock) => entryBlock.getEntry.entryID == dropdownValue);
              Post newPost = Post(
                postID: DateTime.now().millisecondsSinceEpoch,
                description: description,
                entry: widget.entryList[entryId].getEntry,
                user: widget.entryList[entryId].getUser,
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