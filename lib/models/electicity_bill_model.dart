class ElecticityBillModel {
  String due_date;
  double current_bill;
  double current_adjustment;
  List<Record> past_records;

  ElecticityBillModel({
    required this.due_date,
    required this.current_bill,
    required this.current_adjustment,
    required this.past_records,
  });

  factory ElecticityBillModel.fromJson(Map<String, dynamic> json) {
    return ElecticityBillModel(
        due_date: json['due_date'] as String,
        current_bill: json['current_bill'].toDouble(),
        current_adjustment: json['current_adjustment'].toDouble(),
        past_records: (json['past_records'] as List)
            .map((record_json) =>
                Record.fromJson(record_json as Map<String, dynamic>))
            .toList());
  }
}

class Record {
  int month;
  int units;
  double bill;
  double? adjustment;
  double payment;
  Record({
    required this.month,
    required this.units,
    required this.bill,
    this.adjustment,
    required this.payment,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      month: json['month'] as int,
      units: json['units'] as int,
      bill: json['bill'].toDouble(),
      adjustment: json['adjustment'].toDouble(),
      payment: json['payment'].toDouble(),
    );
  }
}
