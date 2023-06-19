import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _home = 'http://192.168.1.7:8000/api/';
  final String _local = 'http://192.168.1.24:8000/api/';
  final String _url = 'http://10.0.2.2:8000/api/';
  final String _imgUrl = 'http://mark.dbestech.com/uploads/';
  getImage() {
    return _imgUrl;
  }

  postData(data, apiUrl) async {
    var fullUrl = _local + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  login(data, apiUrl) async {
    var fullUrl = _local + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  getArticles(apiUrl) async {}

  getPublicData(apiUrl) async {
    var fullUrl = _local + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }
}
