class FirebaseDataModel {
  final String key;
  final Map<String, dynamic> value;

  FirebaseDataModel({required this.key, required this.value});

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
