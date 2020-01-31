import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/wish.dart';
import 'package:myapp/utils/database_helper.dart';

class AddWish extends StatelessWidget {
  final Wish _wishModel;

  AddWish(this._wishModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Wish",
        ),
      ),
      body: Material(
        child: WishForm(this._wishModel),
        elevation: 8.0,
      ),
    );
  }
}

class WishForm extends StatefulWidget {
  final Wish _wishModel;

  WishForm(this._wishModel);

  @override
  _WishFormState createState() {
    return new _WishFormState(_wishModel);
  }
}

class _WishFormState extends State<WishForm> {
  final Wish _wishModel;

  _WishFormState(this._wishModel);

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
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.white), // style for headers
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white), // style for labels
          ),
        ),
        child: CardSettings(
          padding: 10,
          cardElevation: 10,
          children: <Widget>[
            CardSettingsHeader(
              label: 'Wish',
            ),
            CardSettingsText(
              // style: TextStyle(color: Colors.white),
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
                  setState(() => _wishModel.isTimeBound = value ? true : false),
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
              onChanged: (value) => setState(
                  () => _wishModel.isBudgetNeeded = value ? true : false),
            ),
            CardSettingsCurrency(
              label: 'Budget',
              visible: _wishModel.isBudgetNeeded,
              currencyName: '₹',
              currencySymbol: '',
              thousandSeparator: '',
              onChanged: (value) => setState(() => _wishModel.budget = value),
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
                      Navigator.popUntil(context, ModalRoute.withName('/'));
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
                        _wishModel.status = "IN_PROGRESS";
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
      ),
    );
  }
}
