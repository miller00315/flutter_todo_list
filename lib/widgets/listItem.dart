import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildItem(BuildContext context, Map<String, dynamic> item,
    Function onChanged, Function removeItem, int index) {
  return Dismissible(
    background: Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment(-0.9, 0.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    ),
    direction: DismissDirection.startToEnd,
    child: CheckboxListTile(
      title: Text(item["title"]),
      value: item["ok"],
      secondary: CircleAvatar(
        child: Icon(
          item["ok"] ? Icons.check : Icons.error,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      onChanged: (bool value) {
        onChanged(index, value);
      },
    ),
    key: Key(item["id"]),
    onDismissed: (direction) {
      removeItem(index, context);
    },
  );
}
