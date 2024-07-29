import 'package:prueba_1/controllers/connection.dart';
import 'package:prueba_1/models/data_response.dart';
import 'package:prueba_1/models/data_session.dart';

class Services {
  final Connection _con = Connection();

  Future<DataSession> session(Map<dynamic, dynamic> map) async {
    DataResponse rg = await _con.post("user/auth", map, '');

    DataSession session = DataSession();

    session.add(rg);

    if (rg.code == '200') {
      session.token = session.context["token"];
      session.user = session.context["user"];
      session.uid = session.context["uid"];
    }

    return session;
  }

  Future<DataResponse> updateUser(Map<dynamic, dynamic> map) async {
    DataResponse rg = await _con.post("user/update", map, '');

    return rg;
  }

  Future<DataResponse> getUser(dynamic user) async {
    DataResponse rg = await _con.get("user/$user", '');

    return rg;
  }

  Future<DataResponse> getProducts() async {
    DataResponse rg = await _con.get("product/all", '');

    return rg;
  }

  Future<DataResponse> getBranches() async {
    DataResponse rg = await _con.get("branch/all", '');

    return rg;
  }

}
