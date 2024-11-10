class FirebaseDataModel {
  final String key;
  final String? status;
  final Map<String, dynamic> value;

  FirebaseDataModel({required this.key, required this.value, this.status});

  factory FirebaseDataModel.fromJson(Map<String, dynamic> json) {
    return FirebaseDataModel(
      key: json['key'],
      value: json['value'],
    );
  }

  @override
  String toString() {
    return 'FirebaseDataModel{key: $key, value: $value}';
  }
}
