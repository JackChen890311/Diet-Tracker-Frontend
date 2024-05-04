import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';

bool submitLoginForm(formKey) {
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

Future<dynamic> showAddEntryDialog(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var date = '';
    var foodname = '';
    var place = '';
    var price = '';
    var calories = '';
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const CustomText(
            label: 'Please enter a new entry:', color: CustomColor.darkBlue,
            type: 'titleLarge', align: 'left',),
          content: SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.3,
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
                                  return 'Please enter a food name';
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
                                labelText: 'Place',
                                hintText: 'e.g. KFC',
                              ),
                              onSaved: (value) => place = value!,
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
                            ),
                          ),
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
                Map emptyEntry = {};
                Navigator.pop(context, emptyEntry);
              },
            ),
            TextButton(
              child: const CustomText(label: 'Done'),
              onPressed: () {
                var check = submitLoginForm(formKey);
                if (check) {
                  Map<String, dynamic> newEntry = {
                    'date': date,
                    'foodname': foodname,
                    'place': place,
                    'price': price,
                    'calories': calories,
                  };
                  Navigator.pop(context, newEntry);
                }
              },
            ),
          ],
        );
      },);
  }