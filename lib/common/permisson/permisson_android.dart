import 'package:permission_handler/permission_handler.dart';

Future<void> checkPermissionsAll() async {
  if (await Permission.camera.isDenied) {
    await Permission.camera.request();
  }

  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }

  if (await Permission.storage.isDenied) {
    await Permission.contacts.request();
  }

  if (await Permission.microphone.isDenied) {
    await Permission.microphone.request();
  }
}

Future<void> checkPermissionsImage() async {
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
}

Future<void> checkPermissionsContacts() async {
  if (await Permission.contacts.isDenied) {
    await Permission.contacts.request();
  }
}

Future<void> checkPermissionsMicrophone() async {
  if (await Permission.microphone.isDenied) {
    await Permission.microphone.request();
  }
}
