import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermision(Permission permission) async {
  // final permission = Permission.locationAlways;
  final status = await permission.request();
  if (status.isGranted) {
    return true;
  } else if (status.isLimited) {
    return true;
  } else {
    return false;
  }
}
