import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/util/toast.util.dart';
import 'package:url_launcher/url_launcher.dart';

class Noticia extends StatelessWidget {
  NoticiaModel noticia;

  Noticia(this.noticia);

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    this._context = context;

    //Foi adicionado dentro de Container para adicionar margem no item
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(
          left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      elevation: 4.0,
      child: InkWell(
          onTap: () async {
            String url = noticia.url;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              ToastUtil.showToast('Não foi possível abrir a url: $url');
            }
          },
          child: _getListTile()),
    );
  }

  Widget _getListTile() {
    // Foi adicionado dentro de Container para adicionar altura fixa.
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _loadImage(),
        _getColumText(
            this.noticia.titulo, this.noticia.data, this.noticia.resumo),
      ],
    );
  }

  Widget _getColumText(title, date, description) {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _getTitleWidget(title),
          _getDescriptionWidget(description),
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                    child: PopupMenuButton<int>(
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            Share.share(
                                'Veja esta notícia:\n*${this.noticia.titulo}*\n${this.noticia.url}');
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                size: 20.0,
                                color: Colors.grey[600],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Compartilhar"),
                              )
                            ],
                          ),
                        )
                      ],
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    alignment: Alignment.centerRight),
              )
            ],
          )
        ]);
  }

  Widget _getTitleWidget(String curencyName) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
      child: Text(
        curencyName,
        maxLines: 4,
        style: new TextStyle(
            fontSize: 17.9, fontWeight: FontWeight.w400, color: Colors.black),
      ),
    );
  }

  Widget _getDescriptionWidget(String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
      child: Text(
        description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _getDateWidget(String date) {
    return new Text(
      date,
      style: new TextStyle(color: Colors.grey, fontSize: 10.0),
    );
  }

  Widget _loadImage() {
    return new FadeInImage(
      image: Image.network(this.noticia.imagem).image,
      fit: BoxFit.cover,
      width: 185.0,
      height: 185.0,
      placeholder: Image.memory(kTransparentImage).image,
    );
  }
}
