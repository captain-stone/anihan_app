import 'dart:convert';
import 'package:crypto/crypto.dart';

String generate16CharHash(String input) {
  // Generate MD5 hash
  var bytes = utf8.encode(input); // Convert string to bytes
  var md5Hash = md5.convert(bytes).toString();

  // Return the first 8 characters
  return md5Hash.substring(0, 16);
}

String getConversationId(String userId1, String userId2) {
  // Sort the user IDs alphabetically
  List<String> sortedIds = [userId1, userId2]..sort();

  // Combine the sorted IDs with a delimiter
  return "${sortedIds[0]}_${sortedIds[1]}";
}

String getConversationIdHash(String userId1, String userId2) {
  List<String> sortedIds = [userId1, userId2]..sort();
  String combined = "${sortedIds[0]}_${sortedIds[1]}";

  // Generate a hash
  return md5.convert(utf8.encode(combined)).toString();
}
