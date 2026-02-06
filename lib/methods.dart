import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:judyth/db_methods.dart';


void _showTextInput(BuildContext context, TextEditingController textcontroler, String taskName, List memoryList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to push up with the keyboard
      builder: (context) {
        return Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Key for keyboard padding
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Add new Category:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(CupertinoIcons.house, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.person_crop_circle, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.tree, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.bell, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.tortoise, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.rocket, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.phone, size: 30, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: textcontroler,
                  autofocus: true, // Opens keyboard automatically
                  decoration: InputDecoration(
                    hintText: 'Type something...',
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle the submission logic here
                        await insertDB(textcontroler.text, memoryList);
                        textcontroler.clear();
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
    //return(context);
  }