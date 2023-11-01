import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/common/string.dart';
import 'package:my_app/data/models/state_model.dart';
import 'package:my_app/services/network_handler.dart';

class StateRepository {
  static String endpoint = '${AppString.baseURL}states';
  static String? token;
  static StateModel? stateModel;

  Future<StateModel?> getStates() async {
    try {
      token = await NetWorkHandler.storage.read(key: 'token');
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      };
      http.Response response =
          await http.get(Uri.parse('$endpoint/?sort=id%2Casc'), headers: headers);

      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes));
        stateModel = StateModel.fromJson(result);
        return stateModel;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
