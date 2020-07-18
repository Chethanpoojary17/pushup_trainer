class RecordDate {
  String date;
  int sum;

  RecordDate(this.date, this.sum);

  factory RecordDate.fromJson(dynamic json) {
    return RecordDate(json['date'] as String, json['sum'] as int);
  }
  Map toJson() => {
    'date': date,
    'sum': sum,
  };

  @override
  String toString() {
    return '{ ${this.date}, ${this.sum} }';
  }
}