import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uni_discente/models/documento.model.dart';
import 'package:uni_discente/repositories/sessao_download.repository.dart';
import 'package:uni_discente/settings.dart';
import 'package:uni_discente/util/toast.util.dart';

class DownloadService {
  final BuildContext _context;
  DownloadService(this._context);
  Future<void> downloadDocumento(
      String idTurma, DocumentoModel documento) async {
    try {
      _showMaterialDialog(_context);
      var _permissionReady = await _checkPermission();
      var _localPath = (await _findLocalPath());

      var _filename = 'documento_turma_$idTurma.pdf';
      if (_permissionReady) {
        if (_localPath.contains('/storage/emulated/0')) {
          _localPath = '/storage/emulated/0/e-Discente/' +
              Settings.usuario.nome.trim().replaceAll(' ', '_');
          Directory d = Directory(_localPath);
          if (!d.existsSync()) {
            Directory(d.path).createSync(recursive: true);
          }
        }
        print(_localPath);
        var sessaoDownloadModel =
            await SessaoDownload().requestSessaoDownload(idTurma);
        var _dio = Dio();
        final response =
            await _dio.post('https://sig.unilab.edu.br/sigaa/ava/index.jsf',
                data: {
                  'javax.faces.ViewState': sessaoDownloadModel.sessao,
                  'formAva': 'formAva',
                  'formAva:idTopicoSelecionado': '0',
                  'id': documento.id.trim(),
                  documento.formAva.trim(): documento.formAva.trim(),
                },
                options: (Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: {
                    'Cookie':
                        'JSESSIONID=' + sessaoDownloadModel.cookieSessao.trim(),
                    'User-Agent': 'Mozilla/5.0'
                  },
                  followRedirects: false,
                )));
        print(response.headers);
        _filename = response.headers
            .value('content-disposition')
            .split('=')[1]
            .replaceAll('"', '');
        print(_filename);
        int _fileLength = 0;
        await _dio.download('https://sig.unilab.edu.br/sigaa/ava/index.jsf',
            _localPath + '/' + _filename,
            data: {
              'javax.faces.ViewState': sessaoDownloadModel.sessao,
              'formAva': 'formAva',
              'formAva:idTopicoSelecionado': '0',
              'id': documento.id.trim(),
              documento.formAva.trim(): documento.formAva.trim(),
            },
            options: Options(
                contentType: Headers.formUrlEncodedContentType,
                headers: {
                  'Cookie':
                      'JSESSIONID=' + sessaoDownloadModel.cookieSessao.trim(),
                  'User-Agent': 'Mozilla/5.0'
                },
                followRedirects: false,
                method: 'POST'), onReceiveProgress: (rec, res) {
          print(formatBytes(rec));
          _fileLength = rec;
        });
        ToastUtil.showLongToast(
            'Download concluído!\nNome: "$_filename" Tamanho:' +
                formatBytes(_fileLength));
      }
    } catch (e) {
      ToastUtil.showLongToast('Ocorreu um erro ao baixar o Documento');
    } finally {
      Navigator.of(_context).pop();
    }
  }

  Future<String> _findLocalPath() async {
    final directory = Theme.of(this._context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> _checkPermission() async {
    if (Theme.of(this._context).platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  _showMaterialDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: Text("Fazendo Download"),
              content: LinearProgressIndicator(value: null),
            ));
  }

  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}
