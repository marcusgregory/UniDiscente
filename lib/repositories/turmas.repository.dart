import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:uni_discente/models/turma.model.dart';
import 'package:uni_discente/settings.dart';

class TurmasRepository {
  Future<List<TurmaModel>> getTurmas() async {
    try {
      var url = '${Settings.apiURL}/sigaa/turmas';
      http.Response response = await http.get(url, headers: {
        'jwt': Settings.usuario.token
      }).timeout(Duration(seconds: 50));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        Iterable turmas = json['data'];
        return turmas.map((model) => TurmaModel.fromJson(model)).toList();
      } else if (response.statusCode == 400) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else {
        return Future.error('Ocorreu um erro ao obter as turmas');
      }
    } catch (ex) {
      if (ex is SocketException) {
        return Future.error('Ocorreu um erro na conexão com a internet');
      }
      if (ex is TimeoutException) {
        return Future.error('O tempo limite de conexão foi atingido');
      }

      return Future.error(ex);
    }
  }
}
