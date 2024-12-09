import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class MessageData extends AppEntity {
  final String message;
  final String sender;
  final DateTime datetime;

  MessageData(
      {required this.message, required this.sender, required this.datetime});

  @override
  List<Object?> get props => [message, sender, datetime];
}
