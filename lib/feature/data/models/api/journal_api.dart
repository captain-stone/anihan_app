import 'dart:typed_data';

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/dto/journal_entry_dto.dart';
import 'package:anihan_app/feature/domain/parameters/journal_entry_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class JournalApi {
  final logger = Logger();

  Future<ApiResult<List<JournalEntryDto>>> addJournalApi(
      JournalEntryParams params) async {
    User? user = FirebaseAuth.instance.currentUser;
    List<String> photoUrl = [];
    int imageNo = 0;

    try {
      var allJournal = <JournalEntryDto>[];

      final DatabaseReference _ref =
          FirebaseDatabase.instance.ref("journal/journal/${user!.uid}");
      final DatabaseReference _pushRef = _ref.push();
      final generatedKey = _pushRef.key;
      // logger.d(params.photos);

      for (var imageUint in params.photos) {
        String? imageData = await _uploadImageToStorage(
            imageUint,
            "jpg",
            "journal/journal/${user.uid}/$generatedKey/photo",
            "journalPhoto$imageNo",
            imageNo);
        photoUrl.add(imageData ??
            'https://via.placeholder.com/150/000000/FFFFFF/?text=No+Image');
        imageNo++;
      }

      // logger.d(photoUrl);

      JournalEntryDto dto =
          (JournalEntryDto.fromParams(params)).copyWith(id: generatedKey);

      var dtoImage = dto.addImageListWith(images: photoUrl);

      var data = dtoImage.toMap();
      // logger.d(data);

      await _pushRef.set(data);

      DataSnapshot snapshot = await _ref.get();

      if (snapshot.exists) {
        var object = snapshot.value as Map<dynamic, dynamic>?;

        if (object != null) {
          object.forEach((key, value) {
            // logger.d(value);
            final Map<String, dynamic> stringKeyedMap =
                Map<String, dynamic>.from(value as Map);

            // Map<String,
            var data = JournalEntryDto.fromMap(stringKeyedMap);

            allJournal.add(data);
          });
        }
      }

      if (allJournal.isNotEmpty) {
        return ApiResult.success(allJournal);
      } else {
        return const ApiResult.error("There is no saved journal");
      }
    } catch (e) {
      return ApiResult.error("There is an error occured: (error) $e");
    }
  }

  Future<ApiResult<List<JournalEntryDto>>> getAllJournalApi() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<String> photoUrl = [];
    int imageNo = 0;

    try {
      var allJournal = <JournalEntryDto>[];

      final DatabaseReference _ref =
          FirebaseDatabase.instance.ref("journal/journal/${user!.uid}");

      DataSnapshot snapshot = await _ref.get();

      if (snapshot.exists) {
        var object = snapshot.value as Map<dynamic, dynamic>?;

        if (object != null) {
          object.forEach((key, value) {
            final Map<String, dynamic> stringKeyedMap =
                Map<String, dynamic>.from(value as Map);

            // Map<String,
            var data = JournalEntryDto.fromMap(stringKeyedMap);

            allJournal.add(data);
          });
        }
      }

      if (allJournal.isNotEmpty) {
        return ApiResult.success(allJournal);
      } else {
        return const ApiResult.error("There is no saved journal");
      }
    } catch (e) {
      return ApiResult.error("There is an error occured: (error) $e");
    }
  }

  Future<String?> _uploadImageToStorage(Uint8List data, String extension,
      String refs, String fileName, int count) async {
    try {
      String _fileName = '${fileName.replaceAll(' ', '')}$count.$extension';

      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref(refs)
          .child('/$_fileName')
          .putData(data);

      // TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      logger.e('Failed to upload image: $e');
      return null;
    }
  }
}
