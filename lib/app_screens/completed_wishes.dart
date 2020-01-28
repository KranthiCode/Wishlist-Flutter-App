import 'package:flutter/material.dart';
import 'package:myapp/utils/database_helper.dart';

import '../models/wish.dart';
import 'add_wish.dart';

class CompletedList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CompletedListStae();
  }
}

class CompletedListStae extends State<CompletedList> {
  List<Wish> wishesList;
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return _generateListView(context);
  }

  Widget _generateListView(BuildContext context) {
    //some data
    if (wishesList == null) {
      wishesList = List<Wish>();
      _updateCompletedList();
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Material(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        elevation: 8.0,
        child: ListView.builder(
          itemCount: wishesList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(64, 75, 96, .9),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.autorenew, color: Colors.white),
                  ),
                  title: Text(
                    index.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    wishesList[index].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Colors.white, size: 30.0),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddWish(new Wish());
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _updateCompletedList() {
    dbHelper.getAllCompletedWishesList().then((wishesList) {
      setState(() {
        debugPrint('Completed Wishes list fetched...');
        print(wishesList.length);
        this.wishesList = wishesList;
      });
    });
  }
}
