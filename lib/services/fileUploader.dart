import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/helper/constants.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/services/file_management.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'encryption_management.dart';

class FileUploader {
  String chatRoomId;

  FileUploader(this.chatRoomId);

  uploadFile() async {

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);


    if (result != null) {
      print("processing files");
      result.files.forEach((element) {
        uploadTheFileToCloud(element);
      });
    } else {
      // User canceled the picker
    }
  }
  uploadTheFileToCloud (PlatformFile fileUploaded) async {
    DatabaseMethods databaseMethods = new DatabaseMethods();
    FileManagement fileManagement = new FileManagement();
    String aesKey =
    await HelperFunctions.getAESKeysForChatRoom(this.chatRoomId);

    String path = fileUploaded.path!;
    String filename = fileUploaded.name;
    String dirs = await fileManagement.tempPath();
    String dirPath = "encrypted";

    fileManagement.createDirIfNotExists("$dirs/$dirPath");
    Uint8List bin = await File(path).readAsBytes();
    bin.map((e) => print(e));
    Encrypted encryptedData =
    Encryption_Management.encryptBytesWithAESKey(aesKey, bin);
    print("saving encrypted file!!!\n\n");
    File file = File("$dirs/$dirPath/$filename");
    file.writeAsBytes(encryptedData.bytes);
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    print("creating files in firebase");
    String fileReferences = '$chatRoomId/$timeStamp\_$filename';
    await storage.ref(fileReferences).putFile(file);
    Map<String, dynamic> messageMap = {
      "message": filename,
      "references": fileReferences,
      "by": Constants.myName,
      "file": true,
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    await databaseMethods.storeFilesToFirebase(this.chatRoomId, messageMap);

    //testing
    print("Reading the file just now");
    print(await file.readAsBytes());
    Uint8List decryptedData = Encryption_Management.decryptBytesWithAESKey(
        aesKey, await file.readAsBytes());
    print("Recreating the file just now");
    File fileOut = File("$dirs/$filename");
    print(await fileOut.writeAsBytes(decryptedData));
  }
}
