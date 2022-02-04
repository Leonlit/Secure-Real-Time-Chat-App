import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/services/file_management.dart';

class FIleManagerTesting extends StatefulWidget {
  const FIleManagerTesting({Key? key}) : super(key: key);

  @override
  _FIleManagerTestingState createState() => _FIleManagerTestingState();
}

class _FIleManagerTestingState extends State<FIleManagerTesting> {

  testFilePicker () async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    FileManagement fileManagement = new FileManagement();

    if (result != null) {
      List<File> files = result.paths.map((path) async => File(await fileManagement.localPath())).cast<File>().toList();
      print(files.length);
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
