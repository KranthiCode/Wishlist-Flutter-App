class Wish {
  int id;
  String title;
  bool isTimeBound;
  String date;
  bool isBudgetNeeded;
  double budget;
  int priority;
  String status;

  Wish({
    this.id,
    this.title = "",
    this.isTimeBound = false,
    this.date,
    this.isBudgetNeeded = false,
    this.budget = 0.0,
    this.priority = 0,
    this.status,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = this.id;
    }
    map['title'] = this.title;
    map['date'] = this.date;
    map['priority'] = this.priority;
    map['budget'] = this.budget;
    map['isBudgetNeeded'] = this.isBudgetNeeded;
    map['isTimeBound'] = this.isTimeBound;
    map['status'] = this.status;

    return map;
  }

  Wish.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.budget = map['budget'];
    this.priority = map['priority'];
    this.date = map['date'];
    this.isTimeBound = map['isTimeBound'];
    this.isBudgetNeeded = map['isBudgetNeeded'];
  }
}
