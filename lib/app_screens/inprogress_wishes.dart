import 'package:flutter/material.dart';
import 'package:myapp/app_screens/add_wish.dart';
import 'package:myapp/models/wish.dart';
import 'package:myapp/utils/database_helper.dart';

import 'edit_wish.dart';

class InProgressList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InProgressListState();
  }
}

class InProgressListState extends State<InProgressList> {
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
      updateInprogressList();
    }

    return Scaffold(
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: Material(
        color: Color.fromRGBO(194, 201, 214, 1.0),
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
                  onTap: () {
                    print(
                        "Wish id clicked : " + wishesList[index].id.toString());
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditWish(wishesList[index]);
                    }));
                  },
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
                    wishesList[index].id.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    wishesList[index].title +
                        " " +
                        wishesList[index].isTimeBound.toString() +
                        " " +
                        wishesList[index].isBudgetNeeded.toString() +
                        " " +
                        wishesList[index].date,
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
        //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddWish(new Wish());
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void updateInprogressList() {
    dbHelper.getAllWishesList().then((wishesList) {
      setState(() {
        debugPrint('Inprogress Wishes list fetched...');
        print(wishesList.length);
        this.wishesList = wishesList;
      });
    });
  }
}
