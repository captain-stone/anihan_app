// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/dto/calendar_task_dto.dart';
import 'package:anihan_app/feature/services/generate_hash_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class CalendarTaskApi {
  final Logger logger = Logger();

  Future<ApiResult<Map<DateTime, List<CalendarTaskDto>>>> addCalendarTask(
      {required int dateTask, required CalendarTaskDto task}) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      final taskValueList = <CalendarTaskDto>[];
      // final taskDateValueList = <CalendarTaskDateDto>[];

      Map<DateTime, List<CalendarTaskDto>> eventData = {};
      // var dateHashId = generate16CharHash(dateTask);

      final DatabaseReference _ref = FirebaseDatabase.instance
          .ref('journal/calendar/task/${user!.uid}/$dateTask');
      final DatabaseReference _allData =
          FirebaseDatabase.instance.ref('journal/calendar/task/${user.uid}');
      final DatabaseReference _pushRef = _ref.push();
      final generatedKey = _pushRef.key;

      var taskData = task.copyWith(id: generatedKey);

      var data = taskData.toMap();
      await _pushRef.set(data);

      DataSnapshot snapshot = await _allData.get();

      if (snapshot.exists) {
        var object = snapshot.value as Map<dynamic, dynamic>?;
        if (object != null) {
          object.forEach((key, value) {
            logger.d(key); // this is data in miliissss

            logger.d(value); //value with key
            (value as Map).forEach((innerKey, innerValue) {
              Map<String, dynamic> dataValue = {
                "id": innerKey,
                "name": innerValue['name'],
                "status": innerValue['status']
              };

              // _ref.child(innerKey).update(dataValue);

              DateTime dateKey =
                  DateTime.fromMillisecondsSinceEpoch(int.parse(key));

              // Ensure that the list for this date is initialized
              if (eventData[dateKey] == null) {
                eventData[dateKey] = [];
              }
              taskValueList.add(CalendarTaskDto.fromMap(dataValue));
              eventData[dateKey]?.add(CalendarTaskDto.fromMap(dataValue));
              // logger.d(eventData);
            });
            // taskDateValueList.add(CalendarTaskDateDto(
            //     dateTime:
            //         DateTime.fromMillisecondsSinceEpoch(key).toIso8601String(),
            //     data: taskValueList));
          });
        }
        logger.d(eventData);
        if (eventData.isNotEmpty) {
          return ApiResult.success(eventData);
        } else {
          return const ApiResult.error("There's no task saved");
        }

        // if (taskValueList.isNotEmpty) {
        //   return ApiResult.success(CalendarTaskDateDto(
        //       dateTime: DateTime.fromMillisecondsSinceEpoch(dateTask)
        //           .toIso8601String(),
        //       data: taskValueList));
        // } else {
        //   return const ApiResult.error("There's no task saved");
        // }
      } else {
        return const ApiResult.error("There's a problem saving data");
      }
    } catch (e) {
      logger.e(e);
      // rethrow;
      return ApiResult.error("There's an error: (error) $e");
    }
  }

  Future<ApiResult<Map<DateTime, List<CalendarTaskDto>>>>
      getAllCalendarTask() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      final taskValueList = <CalendarTaskDto>[];
      // final taskDateValueList = <CalendarTaskDateDto>[];

      Map<DateTime, List<CalendarTaskDto>> eventData = {};
      // var dateHashId = generate16CharHash(dateTask);

      final DatabaseReference _allData =
          FirebaseDatabase.instance.ref('journal/calendar/task/${user!.uid}');

      DataSnapshot snapshot = await _allData.get();

      if (snapshot.exists) {
        var object = snapshot.value as Map<dynamic, dynamic>?;
        if (object != null) {
          object.forEach((key, value) {
            // logger.d(key); // this is data in miliissss

            // logger.d(value); //value with key
            (value as Map).forEach((innerKey, innerValue) {
              Map<String, dynamic> dataValue = {
                "name": innerValue['name'],
                "status": innerValue['status']
              };

              DateTime dateKey =
                  DateTime.fromMillisecondsSinceEpoch(int.parse(key));

              // Ensure that the list for this date is initialized
              if (eventData[dateKey] == null) {
                eventData[dateKey] = [];
              }
              taskValueList.add(CalendarTaskDto.fromMap(dataValue));
              eventData[dateKey]?.add(CalendarTaskDto.fromMap(dataValue));
              // logger.d(eventData);
            });
          });
        }

        if (eventData.isNotEmpty) {
          return ApiResult.success(eventData);
        } else {
          return const ApiResult.error(
            "There's no task saved",
          );
        }

        // if (taskValueList.isNotEmpty) {
        //   return ApiResult.success(CalendarTaskDateDto(
        //       dateTime: DateTime.fromMillisecondsSinceEpoch(dateTask)
        //           .toIso8601String(),
        //       data: taskValueList));
        // } else {
        //   return const ApiResult.error("There's no task saved");
        // }
      } else {
        return const ApiResult.error("There's a problem saving data",
            errorType: ErrorType.nullError);
      }
    } catch (e) {
      logger.e(e);
      // rethrow;
      return ApiResult.error("There's an error: (error) $e");
    }
  }
}
