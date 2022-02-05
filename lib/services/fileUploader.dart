import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/services/file_management.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'encryption_management.dart';

class FileUploader extends StatefulWidget {
  String chatRoomId;

  FileUploader(this.chatRoomId);

  @override
  _FIleManagerTestingState createState() => _FIleManagerTestingState();
}

class _FIleManagerTestingState extends State<FileUploader> {

  testFilePicker() async {
    FileManagement fileManagement = new FileManagement();
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      String path = result.files.single.path!;
      String filename = result.files.single.name;
      String dirs = await fileManagement.tempPath();
      String dirPath = "encrypted";
      String aesKey =
          await HelperFunctions.getAESKeysForChatRoom("leon123_test123");
      fileManagement.createDirIfNotExists("$dirs/$dirPath");
      Uint8List bin = await File(path).readAsBytes();
      bin.map((e) => print(e));
      Encrypted encryptedData =
          Encryption_Management.encryptBytesWithAESKey(aesKey, bin);
      print(encryptedData.bytes);
      print("saving encrypted file!!!\n\n");
      File file = File("$dirs/$dirPath/$filename");
      file.writeAsBytes(encryptedData.bytes);
      firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
      try {
        print("creating files in firebase");
        await storage
            .ref('leon123_test123/$filename')
            .putFile(file);
      }  catch (e) {
        print("$e\n\n\n");
      }
      //testing
      print("Reading the file just now");
      print(await file.readAsBytes());
      Uint8List decryptedData = Encryption_Management.decryptBytesWithAESKey(aesKey, await file.readAsBytes());
      print("Recreating the file just now");
      File fileOut = File("$dirs/$filename");
      print(await fileOut.writeAsBytes(decryptedData));
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    testFilePicker();
    return Container();
  }
}
