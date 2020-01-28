class Wish {
  int id;
  String title;
  bool isTimeBound;
  String date;
  bool isBudgetNeeded;
  num budget;
  int priority;

  Wish(
      {this.id,
      this.title = "",
      this.isTimeBound = false,
      this.date = '',
      this.isBudgetNeeded =  false,
      this.budget = 0.0,
      this.priority = 0});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = this.id;
    }
    map['title'] = this.title;
    map['date'] = this.date;
    map['priority'] = this.priority;
    map['budget'] = this.budget;

    return map;
  }

  Wish fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.budget = map['budget'];
    this.priority = map['priority'];
    this.date = map['date'];
  }
}
