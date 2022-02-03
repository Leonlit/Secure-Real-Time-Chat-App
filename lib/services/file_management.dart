import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class FileManagement {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> localFile (String filename) async {
    final path = await localPath;
    var status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]); // it should print PermissionStatus.granted
    }
    print(path);
    return File('$path/$filename');
  }

  Future<bool> fileExists (String filePath) {
    return File(filePath).exists();
  }
}