import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:uni_discente/models/perfil.model.dart';
import 'package:uni_discente/stores/perfil.store.dart';
import 'package:uni_discente/util/toast.util.dart';
import '../settings.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen>
    with AutomaticKeepAliveClientMixin {
  final PerfilStore store = PerfilStore();
  @override
  void initState() {
    store.loadPerfil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Observer(builder: (BuildContext context) {
        final future = store.perfilDiscente;

        switch (future.status) {
          case FutureStatus.pending:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text('Carregando perfil...'),
              ],
            );
          case FutureStatus.rejected:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    store.loadPerfil();
                  },
                  icon: Icon(Icons.refresh),
                ),
                Text('Tentar novamente')
              ],
            );
          case FutureStatus.fulfilled:
            return widgetPerfil(future.result);
        }
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget getProfilePic(String url) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.transparent,
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Icon(
          Icons.account_circle,
          color: Colors.grey[300],
          size: 120,
        ),
        errorWidget: (context, url, error) =>
            Icon(Icons.account_circle, color: Colors.grey[300], size: 120),
      ),
    );
  }

  Widget widgetPerfil(PerfilModel perfilModel) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        getProfilePic(Settings.usuario.urlImagemPerfil),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(color: Colors.grey[300], height: 1),
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Nome',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.person),
                  subtitle: Text(Settings.usuario.nome),
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: Settings.usuario.nome));
                    ToastUtil.showToast(
                        'Nome copiado para área de transferência.');
                  },
                ),
                ListTile(
                  title: Text(
                    'Curso',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.school),
                  subtitle: Text(Settings.usuario.curso),
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: Settings.usuario.curso));
                    ToastUtil.showToast(
                        'Curso copiado para área de transferência.');
                  },
                ),
                ListTile(
                  title: Text(
                    'Matrícula',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.offline_pin),
                  subtitle: Text(Settings.usuario.numMatricula),
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: Settings.usuario.numMatricula));
                    ToastUtil.showToast(
                        'Matrícula copiada para área de transferência.');
                  },
                ),
                ListTile(
                  title: Text(
                    'Integralização',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.insert_chart),
                  subtitle: Text(perfilModel.integralizacao + '%'),
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: perfilModel.integralizacao));
                    ToastUtil.showToast(
                        'Integralização copiado para área de transferência.');
                  },
                ),
                ListTile(
                  title: Text(
                    'Nível',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.assistant),
                  subtitle: Text(perfilModel.nivel),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: perfilModel.nivel));
                    ToastUtil.showToast(
                        'Nível copiado para área de transferência.');
                  },
                ),
                ListTile(
                  title: Text(
                    'Situação',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.assignment),
                  subtitle: Text(perfilModel.situacao),
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: perfilModel.situacao));
                    ToastUtil.showToast(
                        'Situação copiada para área de transferência.');
                  },
                ),
                ListTile(
                  title: Text(
                    'Semestre de Entrada',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.event_available),
                  subtitle: Text(perfilModel.semestreEntrada),
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: perfilModel.semestreEntrada));
                    ToastUtil.showToast(
                        'Semestre copiado para área de transferência.');
                  },
                ),
                ListTile(
                  title: Text(
                    'IDE',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.timeline),
                  subtitle: Text(perfilModel.iDE),
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: perfilModel.iDE));
                    ToastUtil.showToast(
                        'IDE copiado para área de transferência.');
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
