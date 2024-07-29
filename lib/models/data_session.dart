import 'package:prueba_1/models/data_response.dart';

class DataSession extends DataResponse{
  
  String token = '';
  String user = '';
  String uid = '';
  String name = '';
  String lastName = '';
  String dni = '';
  
  void add(DataResponse rg){
    code = rg.code;
    msg = rg.msg;
    context = rg.context;
  }

}