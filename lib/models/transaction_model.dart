class TransactionModel {
  String id;
  String description;
  int amount;
  String type; 
  String? imagePath;
  String date;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
      "amount": amount,
      "type": type,
      "imagePath": imagePath,
      "date": date,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json["id"],
      description: json["description"],
      amount: json["amount"],
      type: json["type"],
      imagePath: json["imagePath"],
      date: json["date"],
    );
  }
}
