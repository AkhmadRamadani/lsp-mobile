class CashFlowModel {
  int? id;
  int? amount;
  String? description;
  String? date;
  int? type;

  CashFlowModel({
    this.id,
    this.amount,
    this.description,
    this.date,
    this.type,
  });

  CashFlowModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    description = json['description'];
    date = json['date'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'description': description,
        'date': date,
        'type': type,
      };

  CashFlowModel copyWith({
    int? id,
    int? amount,
    String? description,
    String? date,
    int? type,
  }) {
    return CashFlowModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }
}
