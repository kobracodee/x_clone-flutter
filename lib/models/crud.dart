import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        log("Error: ${response.statusCode}");
      }
    } catch (error) {
      log("catch: ${error.toString()}");
    }
  }

  postRequest(String url, Map data) async {
    try {
      // Ensure all values in the map are strings
      Map<String, String> stringData =
          data.map((key, value) => MapEntry(key, value.toString()));

      var response = await http.post(
        Uri.parse(url),
        body: stringData,
      );

      // log("POST response: ${response.body}");

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        log("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      log("catch: ${error.toString()}");
    }
  }
}
