import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPhotoPermission() async {
  await Permission.photos.request();
  final status = await Permission.photos.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    return false;
  } else {
    final result = await Permission.photos.request();
    return result.isGranted;
  }
}

Future<bool> checkNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isGranted) {
    final requested = await Permission.contacts.request();
    return requested.isGranted;
  } else if (status.isDenied) {
    final requested = await Permission.contacts.request();
    return requested.isGranted;
  } else if (status.isPermanentlyDenied) {
    return false;
  } else {
    final requested = await Permission.contacts.request();
    return requested.isGranted;
  }
}

Future<bool> checkLocationPermission() async {
  final status = await Permission.location.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    final requested = await Permission.location.request();
    return requested.isGranted;
  } else if (status.isPermanentlyDenied) {
    return false;
  } else {
    final requested = await Permission.location.request();
    return requested.isGranted;
  }
}
