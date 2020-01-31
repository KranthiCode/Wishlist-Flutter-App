import 'package:flutter/material.dart';

import 'completed_wishes.dart';
import 'inprogress_wishes.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  List<Widget> _bottomTabs;

  @override
  void initState() {
    _bottomTabs = [
      InProgressList(),
      CompletedList(),
      ProfilePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(117, 133, 163, 1.0),
        title: Text("My Wish List"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          )
        ],
      ),
      body: _bottomTabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(117, 133, 163, 1.0),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work, color: Colors.white),
            title: Text('In Progress', style: TextStyle(color: Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in, color: Colors.white),
            title: Text('Completed', style: TextStyle(color: Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            title: Text('Profile', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context){
//            return AddWish();
//          }));
//        },
//        child: Icon(Icons.add),
//      ),
    );
  }
}
