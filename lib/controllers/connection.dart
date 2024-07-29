import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_1/models/data_response.dart';

class Connection {
  
  final String url = "http://192.168.3.28:5000/";

  Future<DataResponse> get(String resource, String key) async {
    
    final String endpoint = url + resource;

    Map<String, String> headers = {'Content-Type': 'application/json'};
    
    if (key != '') {
      headers = {'Content-Type': 'application/json', 'X-Access-Token': key};
    }

    final uri = Uri.parse(endpoint);

    final response = await http.get(uri, headers: headers);
    Map<dynamic, dynamic> body = jsonDecode(response.body);

    return _response(body["code"].toString(), body["msg"], body["context"]);
  }

  Future<DataResponse> post(String resource, Map<dynamic, dynamic> map, String key) async {
    
    final String endpoint = url + resource;
    
    Map<String, String> headers = {'Content-Type': 'application/json'};
    
    if (key != '') {
      headers = {'Content-Type': 'application/json', 'X-Access-Token': key};
    }
    
    final uri = Uri.parse(endpoint);

    final response = await http.post(uri, headers: headers, body: jsonEncode(map));
    //if(response.statusCode == 200) {
    Map<dynamic, dynamic> body = jsonDecode(response.body);
    return _response(body["code"].toString(), body["msg"], body["context"]);
    //}
  }

  DataResponse _response(String code, String msg, dynamic map) {
    var response = DataResponse();

    response.msg = msg;
    response.code = code;
    response.context = map;

    return response;
  }

}
