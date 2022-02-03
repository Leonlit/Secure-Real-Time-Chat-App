

import 'dart:convert';


main () {
  Map<String, dynamic> jsonMap = {
    "chatRoomID": "test",
    "key": "test_key"
  };
  List<Map<String, dynamic>> data = [jsonMap];
  String jsonData = jsonEncode(data);
  print(jsonData);

  List<dynamic> jsonDecodedData = jsonDecode(jsonData);

  print(jsonDecodedData.length);
  print(jsonDecodedData[0]);
}