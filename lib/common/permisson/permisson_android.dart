import 'package:permission_handler/permission_handler.dart';

Future<void> checkPermissionsAll() async {
  if (await Permission.camera.isDenied) {
    await Permission.camera.request();
  }

  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
}

Future<void> checkPermissionsImage() async {
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
}
