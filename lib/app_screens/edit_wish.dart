import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/wish.dart';
import 'package:myapp/utils/database_helper.dart';

class EditWish extends StatelessWidget {
  final Wish _wishModel;

  EditWish(this._wishModel);

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
        child: EditWishForm(this._wishModel),
        elevation: 8.0,
      ),
    );
  }
}

class EditWishForm extends StatefulWidget {
  final Wish _wishModel;

  EditWishForm(this._wishModel);

  @override
  _EditWishFormState createState() {
    return new _EditWishFormState(_wishModel);
  }
}

class _EditWishFormState extends State<EditWishForm> {
  final Wish _wishModel;

  _EditWishFormState(this._wishModel);

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
              //color: Colors.white,
            ),
          ),
          CardSettingsText(
            //style: TextStyle(color: Colors.white),
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
            onChanged: (value) => setState(() {
              if (value && _wishModel.date == "") {
                _wishModel.date = DateTime.now().toString();
              }
              _wishModel.isTimeBound = value;
            }),
          ),
          CardSettingsDatePicker(
            label: 'Target Date',
            visible: _wishModel.isTimeBound,
            initialValue: _wishModel.isTimeBound
                ? DateTime.parse(_wishModel.date)
                : DateTime.now(),
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
            initialValue: _wishModel.isBudgetNeeded ? _wishModel.budget : 0.0,
            visible: _wishModel.isBudgetNeeded != null
                ? _wishModel.isBudgetNeeded
                : false,
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
            initialValue: _wishModel.priority,
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
                    debugPrint("Wish id: " +
                        _wishModel.id.toString() +
                        " is going to be deleted.");
                    dbHelper.deleteWish(_wishModel.id).then((value) {
                      debugPrint("Wish has been delete");
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    });
                  },
                  icon: Icon(Icons.delete),
                  label: Text(
                    "Delete",
                  ),
                  shape: RoundedRectangleBorder(),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      debugPrint(
                          'validation complete and going to save the wish');
                      dbHelper.updateWish(_wishModel).then((id) {
                        setState(() {
                          debugPrint("Wish model has been updated with");
                        });
                      });
                    } else {
                      print('there is some error');
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text(
                    "Update",
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
