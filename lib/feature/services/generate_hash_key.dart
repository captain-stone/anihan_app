import 'dart:convert';
import 'package:crypto/crypto.dart';

String generate16CharHash(String input) {
  // Generate MD5 hash
  var bytes = utf8.encode(input); // Convert string to bytes
  var md5Hash = md5.convert(bytes).toString();

  // Return the first 8 characters
  return md5Hash.substring(0, 16);
}
