import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:sudoku/Board.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Nyandoku',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(
        title: 'Nyandoku',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<MyHomePage> {
  static String toImg(int s){
    return 'set2/' + s.toString() + '.png';
  }


  List<List<int>> imgList = [
    [0,0,0,2,6,0,7,0,1],
    [6,8,0,0,7,0,0,9,0],
    [1,9,0,0,0,4,5,0,0],
    [8,2,0,1,0,0,0,4,0],
    [0,0,4,6,0,2,9,0,0],
    [0,5,0,0,0,3,0,2,8],
    [0,0,9,3,0,0,0,7,4],
    [0,4,0,0,5,0,0,3,6],
    [7,0,3,0,1,8,0,0,0],
  ];

  List<List<int>> initList = [
    [0,0,0,2,6,0,7,0,1],
    [6,8,0,0,7,0,0,9,0],
    [1,9,0,0,0,4,5,0,0],
    [8,2,0,1,0,0,0,4,0],
    [0,0,4,6,0,2,9,0,0],
    [0,5,0,0,0,3,0,2,8],
    [0,0,9,3,0,0,0,7,4],
    [0,4,0,0,5,0,0,3,6],
    [7,0,3,0,1,8,0,0,0],
  ];

  static int count = 0;
  static int cursor = 0;
  HashSet<RowCol> conflicts = new HashSet<RowCol>();

  void changeConflicts() {
    conflicts = Conflict.getConflicts(imgList);
  }

  static void changeCursor(i){
    cursor = i;
  }

  // Resets the whole board.
  void reset() {
    setState(() {
      imgList = new List<List<int>>.generate(9, (i) => new List<int>.from(initList[i]));
      changeConflicts();
    });
  }

  Color getHighlightColor(int r, int c) {
    bool isConflict = conflicts.contains(new RowCol(r, c));
    bool isChangable = initList[r][c] == 0;
    if (isConflict && !isChangable) return Colors.red[900];
    else if (isConflict)            return Colors.red[100];
    else if (!isChangable)          return Colors.grey;
    else                            return Colors.white;
  }

  List<TableRow> getTableRowLst() {
    List<TableRow> lst = new List<TableRow>();
    for (int r = 0; r < 9; r++) {
      lst.add(getTableRow(r));
    }
    return lst;
  }

  TableRow getTableRow(r) {
    List<Widget> lst = new List<Widget>();
    for (int c = 0; c < 9; c++) {
      lst.add(new Container(
        color: getHighlightColor(r, c),
        child: new IconButton(
          icon: Image.asset(
            toImg(imgList[r][c]),
          ),
          iconSize: 24.0,
          onPressed: (){
            if(initList[r][c] == 0) {
              setState(() {
              imgList[r][c] = cursor;
               changeConflicts();
              });
            }
          }
        ),
      ));
    }
    return new TableRow(children: lst);
  }

  List<TableRow> getKeyRowlst() {
    List<TableRow> lst = new List<TableRow>();
    lst.add(getKeyRow(0));
    lst.add(getKeyRow(5));
    return lst;
  }

  TableRow getKeyRow(int c) {
    List<Widget> lst = new List<Widget>();
    for (int i = 0; i <= 4; i++) {
      Color containerColor = Colors.white;
      if (cursor == i+c) containerColor = Colors.lightGreenAccent;
      lst.add(new Container(
        color: containerColor,
        child: new IconButton(
          icon: Image.asset('set2/'+(i + c).toString()+'.png'),
          iconSize: 35.0,
          onPressed: () {
            setState(() {
              changeCursor(i + c);
            });
          },
        ),
      ),
      );
    }
    return new TableRow(children: lst);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Sudoku Cat'),
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget> [
              new ListTile(
                title: new Text('Reset'),
                onTap: () {
                  reset();
                  Navigator.pop(context);
                },
              ),
              new ListTile(
                title: new Text('New Game'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ]
          )
        ),
        backgroundColor: Colors.white,
        body: new Column(
          children:[
          new Table(
            children: getTableRowLst(),
            border: new TableBorder.all(
                color: Colors.blueAccent
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(top:40.0),
            child: new Table(
              children: getKeyRowlst(),
              border: new TableBorder.all(
                  color: Colors.redAccent,
              ),
            )
          )

    ]
        ));
  }
}