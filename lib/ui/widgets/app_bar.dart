import 'package:flutter/material.dart';

AppBar appBar(
    BuildContext context, IconButton iconButton, Widget iconButton2) {
  return AppBar(
    leading: iconButton,
    elevation: 0,
    backgroundColor: Theme.of(context).dialogBackgroundColor,
    actions: [
      Row(
        children: [
          iconButton2,
          const Padding(
            padding: EdgeInsets.only(right: 30, top: 10),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/person.jpeg'),
              radius: 25,
            ),
          ),
        ],
      ),
    ],
  );
}
