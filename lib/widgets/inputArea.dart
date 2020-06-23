import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildInputArea(TextEditingController controller, Function add) {
  return Row(
    children: <Widget>[
      Expanded(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Nova tarefa',
            labelStyle: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
      RaisedButton(
        onPressed: add,
        color: Colors.blueAccent,
        child: Text(
          'ADD',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      )
    ],
  );
}
