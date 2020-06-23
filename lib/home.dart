import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_list/utils/files.dart';
import 'package:to_do_list/widgets/inputArea.dart';
import 'package:to_do_list/widgets/listItem.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();

  List _toDoList = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();

    readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDoList() {
    setState(() {
      Map<String, dynamic> newToDo = Map();

      newToDo["id"] = DateTime.now().microsecondsSinceEpoch.toString();

      newToDo["title"] = _toDoController.text;

      newToDo["ok"] = false;

      _toDoController.clear();

      _toDoList.add(newToDo);

      saveData(_toDoList);
    });
  }

  void _removeToDoList(int index, BuildContext context) {
    setState(() {
      _lastRemoved = Map.from(_toDoList[index]);
      _lastRemovedPos = index;

      _toDoList.removeAt(index);

      saveData(_toDoList);

      final snack = SnackBar(
        content: Text('Tarefa "${_lastRemoved["title"]}" removida'),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              _toDoList.insert(index, _lastRemoved);
              saveData(_toDoList);
            });
          },
        ),
        duration: Duration(seconds: 2),
      );

      Scaffold.of(context).removeCurrentSnackBar();

      Scaffold.of(context).showSnackBar(snack);
    });
  }

  void _onChanged(int index, bool value) {
    setState(() {
      _toDoList[index]["ok"] = value;
      saveData(_toDoList);
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((first, second) {
        if (first['ok'] && !second['ok'])
          return 1;
        else if (!first['ok'] && second['ok'])
          return -1;
        else
          return 0;
      });

      saveData(_toDoList);
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'Lista de tarefas',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7, 1.0),
            child: buildInputArea(_toDoController, _addToDoList),
          ),
          Expanded(
            child: RefreshIndicator(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  return buildItem(context, _toDoList[index], _onChanged,
                      _removeToDoList, index);
                },
              ),
              onRefresh: _refresh,
            ),
          ),
        ],
      ),
    );
  }
}
