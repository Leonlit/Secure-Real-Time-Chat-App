import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class FileManagement {
  Future<String> localPath () async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> localFile (String filename) async {
    final path = await localPath();
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

  Future<String?> getExternalDirPath () async{
    Directory? dirPath = await getExternalStorageDirectory();
    String? path = dirPath?.path;
    return path;
  }

  Future<bool> dirExists(String dirPath) async{
    return await Directory(dirPath).exists();
  }

  Future<bool> createDirIfNotExists (String dirPath) async{
    if (await dirExists(dirPath)) {
      return true;
    }else {
      Directory(dirPath).create()
          .then((value) {
        return true;
      });
    }
    return false;
  }
}