import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:myapp/models/wish.dart';
import 'package:myapp/utils/database_helper.dart';

class AddWish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(
          "Add Wish",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Material(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: WishForm(),
        elevation: 8.0,
      ),
    );
  }
}

class WishForm extends StatefulWidget {
  @override
  _WishFormState createState() {
    return new _WishFormState();
  }
}

class _WishFormState extends State<WishForm> {
  final _wishModel = new Wish();
  DatabaseHelper dbHelper = DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusTitleNode;

  @override
  void initState() {
    super.initState();
    focusTitleNode = FocusNode();
  }

  @override
  void dispose() {
    focusTitleNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CardSettings(
        padding: 10,
        cardElevation: 20,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: CardSettingsHeader(
              label: 'Wish',
              color: Colors.white,
            ),
          ),
          CardSettingsText(
            style: TextStyle(color: Colors.white),
            autofocus: true,
            label: 'Title',
            initialValue: _wishModel.title,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Title is required.';
              } else {
                _wishModel.title = value;
                return null;
              }
            },
          ),
          CardSettingsSwitch(
            label: 'Time Specific?',
            initialValue: _wishModel.isTimeBound,
            onChanged: (value) =>
                setState(() => _wishModel.isTimeBound = value),
          ),
          CardSettingsDatePicker(
            label: 'Target Date',
            visible: _wishModel.isTimeBound,
            initialValue: DateTime.now(),
            onChanged: (value) =>
                setState(() => _wishModel.date = value.toString()),
            validator: (value) {
              if (_wishModel.isTimeBound) {
                _wishModel.date = value.toString();
              } else {
                _wishModel.date = "";
              }
              return null;
            },
          ),
          CardSettingsSwitch(
            label: 'Budget?',
            initialValue: _wishModel.isBudgetNeeded,
            onChanged: (value) =>
                setState(() => _wishModel.isBudgetNeeded = value),
          ),
          CardSettingsCurrency(
            label: 'Budget',
            initialValue: _wishModel.budget,
            visible: _wishModel.isBudgetNeeded,
            currencyName: '₹',
            currencySymbol: '',
            validator: (value) {
              if (_wishModel.isBudgetNeeded && !(value > 0)) {
                return "Budget must be greater than zero";
              }
              return null;
            },
          ),
          CardSettingsNumberPicker(
            max: 5,
            min: 0,
            label: "Priority",
            initialValue: 2,
            onChanged: (value) => setState(() => _wishModel.priority = value),
            validator: (value) {
              _wishModel.priority = value;
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    debugPrint("discard key pressed");
                  },
                  icon: Icon(Icons.delete),
                  label: Text(
                    "Discard",
                  ),
                  shape: RoundedRectangleBorder(),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      debugPrint(
                          'validation complete and going to save the wish');
                      dbHelper.insertWish(_wishModel).then((id) {
                        setState(() {
                          this._wishModel.id = id;
                          debugPrint("Wish model has been saved with id : " +
                              id.toString());
                        });
                      });
                    } else {
                      print('there is some error');
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text(
                    "Save",
                  ),
                  shape: RoundedRectangleBorder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
